# camel-cli-oci
Camel JBang running in a container based on UBI9 with Openjdk 17

## Build image

using version of Camel CLI corrisponding on the release in https://github.com/redhat-camel/jbang-catalog (i.e. 4.10.3)

```
JB_TAG=4.10.3 ; podman build --build-arg JB_TAG=$JB_TAG -t camel-cli:$JB_TAG .
```

## Run camel cli from container

mount folder to share files and then executes the commands

```
podman run --rm -v $(pwd):/ws:Z camel-cli:4.10.3 run SampleRouterBuilder.java
```

or run it from external files

```
podman run camel-cli:4.10.3 run https://github.com/apache/camel-kamelets-examples/tree/main/jbang/hello-java
```

if you want to persist maven dependencies across executions you can mount `/home/default/.m2/repository` folder

```
podman run --userns=keep-id:uid=185 --rm -v /tmp/repository:/home/default/.m2/repository:Z -v $(pwd):/ws:Z camel-cli:4.10.3 run SampleRouterBuilder.java
```

### Run camel console

it is possible to map container port 8080 to access to the console

```
podman run --rm -p 8080:8080 -v $(pwd):/ws:Z camel-cli:4.10.3 run --console SampleRouterBuilder.java
```

then the console will be accessible via http://localhost:8080/q/dev

### Create alias

to easly run the command it is possible to create the alias (the shared maven repo make the command re-runnable without downloadind the maven artifacts again)

on linux with selinux enabled the alias could be
```
alias camel-cli='mkdir -p /tmp/camel-cli-maven-repo && podman run --userns=keep-id:uid=185 --rm --network host -v /tmp/camel-cli-maven-repo:/home/default/.m2/repository:Z -v $(pwd):/ws:Z quay.io/mcarlett/camel-cli:4.10.3'
```

then it is possible to use the container

```
camel-cli version
```

### multiple command in the same execution

if you need to run multiple commands that creates configurations or files, it is necessary to keep the container running and interact with it

start the container mounting current directory
```
podman run --userns=keep-id:uid=185 --rm --network host -it --entrypoint bash -v $(pwd):/ws:Z quay.io/mcarlett/camel-cli:4.10.3
```

then, once the command bash is executing inside the container, it is possible to have the interactive containerized environment
```
camel export --runtime=quarkus --gav=com.foo:acme:1.0-SNAPSHOT --dir=acme

camel run acme/src/main/java/com/foo/acme/SampleRouterBuilder.java
```

to exit from the container just type `exit` from the container to terminate the bash session

### Run infrastructure

to easly start an [infrastructure component](https://camel.apache.org/manual/camel-jbang.html#_infrastructure), run the container in the host network mode 

```
run --rm --network host camel-cli:4.10.3 infra run ftp
```