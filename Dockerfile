#
# Prometheus Alertmanager Dockerfile
#
# https://github.com/
#

# Pull base image.
FROM debian:latest

LABEL org.opencontainers.image.authors="hihouhou < hihouhou@hihouhou.com >"

ENV GOROOT=/usr/local/go
ENV GOPATH=/opt/prometheus
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH
ENV ALERTMANAGER_VERSION=v0.28.1
ENV GO_VERSION=1.21.0
ENV USER=ROOT

# Update & install packages for prometheus alertmanager build
RUN apt-get update && \
    apt-get install -y wget git make build-essential curl npm

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

RUN useradd -ms /bin/bash alertmanager

RUN mkdir -p /var/lib/prometheus/alertmanager/data && \
    chown -R alertmanager: /var/lib/prometheus && \
    ln -s $GOPATH/src/github.com/prometheus/alertmanager /usr/local/sbin/alertmanager

USER alertmanager

EXPOSE 9093

COPY your_config.yml your_config.yml

CMD ["alertmanager", "--config.file=your_config.yml", "--storage.path=/var/lib/prometheus/alertmanager/"]
