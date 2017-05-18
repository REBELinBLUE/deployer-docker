FROM node:alpine

RUN \
    echo -e 'http://dl-cdn.alpinelinux.org/alpine/edge/main\nhttp://dl-cdn.alpinelinux.org/alpine/edge/community\nhttp://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
    && apk --no-cache --update add yarn supervisor openssh git \
    && rm /etc/supervisord.conf \
    && mkdir -p /etc/supervisor/conf.d \
    && mkdir /var/log/supervisor \
    && rm -rf /var/cache/apk/*

COPY supervisord.conf /etc/supervisor
