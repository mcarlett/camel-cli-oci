# camel-cli-oci
Camel JBang running in a container based on UBI9 with Openjdk 17

## Build image

using version of Camel CLI corrisponding on the release in https://github.com/redhat-camel/jbang-catalog (i.e. 4.10.3)

```
podman build -t camel-cli:4.10.3 .
```

## Run camel cli from container

mount folder to share files and then executes the commands

```
podman run --rm -v $(pwd):/ws:Z camel-cli:4.10.3 run /ws/SampleRouterBuilder.java
```

or run it from external files

```
podman run camel-cli:4.10.3 run https://github.com/apache/camel-kamelets-examples/tree/main/jbang/hello-java
```

if you want to persist maven dependencies across executions you can mount `/home/default/.m2/repository` folder

```
podman run --rm -v /tmp/repository:/home/default/.m2/repository:Z -v $(pwd):/ws:Z camel-cli:4.10.3 run /ws/SampleRouterBuilder.java
```

### Run camel console

it is possible to map container port 8080 to access to the console

```
podman run --rm -p 8080:8080 -v $(pwd):/ws:Z camel-cli:4.10.3 run --console /ws/SampleRouterBuilder.java
```

then the console will be accessible via http://localhost:8080/q/dev
