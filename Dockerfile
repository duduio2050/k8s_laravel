FROM php:8.4-fpm

WORKDIR /var/www

RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    nginx \
    supervisor

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . .

RUN composer install --no-dev --optimize-autoloader

RUN cp .env.example .env && php artisan key:generate

# Nginx 설정
COPY docker/nginx.conf /etc/nginx/sites-available/default

# Supervisor 설정
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
