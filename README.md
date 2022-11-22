# camel-cli-oci
Camel JBang running in a container based on UBI9 with Openjdk 17

## Build image

using latest version of camel cli in branch main https://github.com/apache/camel 

```
podman build -t camel-cli:latest .
```

for specific version of camel, use the branch/tag

```
podman build --no-cache --build-arg CAMEL_REF=camel-3.18.3 -t camel-cli:3.18.3 .
```

## Run camel cli from container

mount folder to share files and then executes the commands

```
podman run --rm -v $(pwd):/ws:Z camel-cli:latest run /ws/SampleRouterBuilder.java
```

or run it from external files

```
podman run camel-cli:latest run https://github.com/apache/camel-kamelets-examples/tree/main/jbang/hello-java
```