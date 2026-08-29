# One image for web, workers, scheduler and the migrate hook. The command
# differs; the code must not.
FROM dunglas/frankenphp:1-php8.4-alpine

# Extensions the platform assumes: Postgres, Redis for Valkey, intl for dates
# and currency, and the ones Laravel wants for images and archives.
RUN install-php-extensions \
        pdo_pgsql pgsql \
        redis \
        intl \
        zip \
        gd \
        opcache \
        pcntl \
    && apk add --no-cache git

WORKDIR /app

# Dependencies are their own layer, so a code change does not re-resolve them.
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY composer.json composer.lock* ./
RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist --no-interaction

COPY . .

# The directories Laravel writes into have to exist before anything asks it to
# discover packages, and git does not carry empty directories.
RUN mkdir -p storage/framework/cache/data storage/framework/sessions \
        storage/framework/views storage/logs bootstrap/cache \
    && composer dump-autoload --optimize --no-dev --classmap-authoritative \
    && php artisan package:discover --ansi \
    && chown -R www-data:www-data storage bootstrap/cache

# Defaults that let the image start with no environment at all.
#
# Laravel ships with SQLite and a database session driver, so the very first
# request touches a database that is not there -- which makes the image
# impossible to try, and makes the readiness probe fail before Postgres is up.
# The portal overrides every one of these per environment.
ENV SERVER_NAME=:8080 \
    APP_ENV=production \
    APP_DEBUG=false \
    LOG_CHANNEL=stderr \
    DB_CONNECTION=pgsql \
    SESSION_DRIVER=cookie \
    CACHE_STORE=file \
    QUEUE_CONNECTION=sync

EXPOSE 8080

# The chart overrides this for workers, the scheduler and the migrate job.
CMD ["frankenphp", "run", "--config", "/app/Caddyfile"]
