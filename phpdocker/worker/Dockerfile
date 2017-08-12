FROM nielsvdoorn/laravel-supervisor

RUN apk --update add openssh && \
    rm /var/cache/apk/* && \
    mkdir -p /var/log/supervisor/

WORKDIR /application
