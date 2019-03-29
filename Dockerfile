#
# Prometheus Alertmanager Dockerfile
#
# https://github.com/
#

# Pull base image.
FROM debian:latest

MAINTAINER hihouhou < hihouhou@hihouhou.com >

ENV GOROOT /usr/local/go
ENV GOPATH /opt/prometheus
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH
ENV ALERTMANAGER_VERSION v0.16.0
ENV GO_VERSION 1.12.1 
ENV USER ROOT

# Update & install packages for prometheus alertmanager build
RUN apt-get update && \
    apt-get install -y wget git make build-essential curl

# Get go
RUN wget https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -xvf go${GO_VERSION}.linux-amd64.tar.gz && \
    mv go /usr/local

# Get prometheus alertmanagerfrom github
RUN mkdir -p $GOPATH/src/github.com/prometheus && \
    cd $GOPATH/src/github.com/prometheus && \
    wget https://api.github.com/repos/prometheus/alertmanager/tarball/${ALERTMANAGER_VERSION} -O ${ALERTMANAGER_VERSION}.tar.gz && \
    tar xf  ${ALERTMANAGER_VERSION}.tar.gz --strip-components=1 && \
    make build

EXPOSE 9093

WORKDIR $GOPATH/src/github.com/prometheus

COPY your_config.yml your_config.yml

CMD ["./alertmanager", "--config.file=your_config.yml"] 
