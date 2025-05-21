FROM registry.redhat.io/ubi9/openjdk-17:latest

USER root

RUN microdnf update -y

USER default

ARG JB_TAG

LABEL org.opencontainers.image.version="$JB_TAG"

RUN curl -Ls https://sh.jbang.dev | bash -s - app setup \
    && source ~/.bashrc \
    && jbang version --update \
    && jbang trust add https://github.com/redhat-camel/jbang-catalog/ \
    && jbang app install camel@redhat-camel/jbang-catalog/$JB_TAG

#config repos for jbang
RUN source ~/.bashrc \
    && camel config set repos=https://maven.repository.redhat.com/ga/,https://maven.repository.redhat.com/earlyaccess/all/

#config repos for maven
RUN xml="\n\
    <activeProfile>jboss-eap-repository</activeProfile>\n\
    <!-- ### active profiles ### -->" \
    && sed -i "s|<!-- ### active profiles ### -->|${xml}|" "/home/default/.m2/settings.xml"


ENV PATH=/home/default/.jbang/bin:$PATH

WORKDIR /ws

ENTRYPOINT ["camel"]
CMD ["--help"]
