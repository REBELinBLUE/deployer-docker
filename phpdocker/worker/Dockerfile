FROM nielsvdoorn/laravel-supervisor

RUN apk --update --no-cache add openssh bash && \
    mkdir -p /var/log/supervisor/

WORKDIR /application
