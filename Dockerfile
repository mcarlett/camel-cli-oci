FROM registry.redhat.io/ubi9/openjdk-17:latest

ARG CAMEL_REF=main

RUN curl -Ls https://sh.jbang.dev | bash -s - app setup \
    && source ~/.bashrc \
    && jbang trust add https://github.com/apache/camel/ \
    && jbang app install camel@apache/camel/$CAMEL_REF

# hawtio
EXPOSE 8888 

ENV PATH=/home/default/.jbang/bin:$PATH

ENTRYPOINT ["camel"]
CMD ["--help"]
