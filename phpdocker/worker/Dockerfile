FROM nielsvdoorn/laravel-supervisor

RUN rm -r /var/lib/apt/lists/*
WORKDIR /etc/supervisor/conf.d/

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
