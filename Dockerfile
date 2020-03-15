FROM alpine:latest
MAINTAINER pch18.cn

COPY settings.json /root/.config/transmission-daemon/settings.json

WORKDIR /

RUN apk update \
    && apk add git cmake make g++ curl-dev libevent-dev \
    && git clone https://github.com/pch18-fork/transmission.git \
    && cd ./transmission \
    && git submodule update --init \
    && mv ./web/index.html ./web/index.original.html \
    && mv ./web-chinese/src/* ./web \
    && mkdir build \
    && cd ./build \
    && cmake .. \
    && make \
    && make install \
    && apk del git cmake make g++ curl-dev libevent-dev \
    && rm -rf /transmission
    
EXPOSE 9091 51413/tcp 51413/udp

CMD  ["-f","-u","admin","-v","123456"]

ENTRYPOINT ["/usr/bin/transmission-daemon"]

VOLUME /root/.config/
