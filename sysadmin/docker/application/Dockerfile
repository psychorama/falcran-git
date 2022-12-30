ARG BUILD_ENVIRONMENT_NAME=prod
ARG BUILD_ENVIRONMENT_DEBUG=0
FROM home.psychorama.be:4560/falcran/falcran-composer:latest as composer
WORKDIR /app

COPY composer.json composer.lock .env /app/

RUN composer install --no-scripts --no-autoloader && \
    composer dump-autoload --optimize && \
    composer dump-env ${BUILD_ENVIRONMENT_NAME:-prod}

FROM home.psychorama.be:4560/falcran/falcran-node:latest as node
WORKDIR /app

COPY . /app/

RUN yarn install && \
    yarn build

FROM home.psychorama.be:4560/falcran/falcran-apache-php-8.2:latest

USER root

RUN set -ex; \
  { \
    echo "; Docker php-settings"; \
    echo "memory_limit = -1"; \
    echo "max_execution_time = 0"; \
    echo "; File upload"; \
    echo "upload_max_filesize = 150M"; \
    echo "post_max_size = 200M"; \
    echo "; Configure Opcache for Containers"; \
    echo "opcache.enable = On"; \
    echo "opcache.validate_timestamps = Off"; \
    echo "; Configure Opcache Memory (Application-specific)"; \
    echo "opcache.memory_consumption = 256"; \
    echo "opcache.max_accelerated_files=20000"; \
    echo "realpath_cache_size=4096K"; \
    echo "realpath_cache_ttl=600"; \
    echo "opcache.preload=/var/www/app/config/preload.php"; \
    echo "opcache.preload_user=app"; \
    echo "display_errors=Off"; \
    echo "date.timezone=Europe/Brussels"; \
  } > "$PHP_INI_DIR/conf.d/docker-php.ini"

WORKDIR /var/www/app

COPY ./sysadmin/docker/application/ssl/server.cnf /etc/apache2/certs/
RUN rm -f /etc/apache2/certs/server.crt && \
    rm -f /etc/apache2/certs/server.key && \
    openssl req -nodes -new -keyout /etc/apache2/certs/server.key \
      -out /etc/apache2/certs/server.csr -config /etc/apache2/certs/server.cnf > /dev/null 2> /dev/null && \
    openssl x509 -days 365 -req -in /etc/apache2/certs/server.csr \
      -CA /usr/local/share/ca-certificates/falcran-ca.crt \
      -CAkey /etc/apache2/certs/falcran-ca.key -set_serial 123 \
      -out /etc/apache2/certs/server.crt -extfile /etc/apache2/certs/server.cnf \
      -extensions 'v3_req' > /dev/null 2> /dev/null && \
    chmod 644 /etc/apache2/certs/server.*

COPY ./sysadmin/docker/application/conf/app.conf /etc/apache2/sites-available/
COPY --from=composer --chown=app:app /app/vendor /var/www/app/vendor
COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=node --chown=app:app /app/public/assets /var/www/app/public/assets
COPY --chown=app:app . /var/www/app/

RUN mkdir -p /var/www/app/var/tmp && \
    mkdir -p /var/www/app/var/log && \
    mkdir -p /var/www/app/var/cache/prod && \
    mkdir -p /var/www/app/var/cache/dev && \
    chown -R app:app /var/www/app && \
    chmod 777 /var/www/app/var/tmp

RUN a2enmod rewrite && \
    a2enmod cgid && \
    a2enmod remoteip && \
    a2enmod ssl && \
    a2enmod auth_digest && \
    a2dissite 000-default && \
    a2ensite app

COPY ./sysadmin/docker/application/conf/startup.sh /startup.sh
RUN chmod +x /startup.sh
USER app

ENV APP_ENV ${BUILD_ENVIRONMENT_NAME:-prod}
ENV APP_DEBUG ${BUILD_ENVIRONMENT_DEBUG:-0}

ENTRYPOINT [ "/startup.sh"]
