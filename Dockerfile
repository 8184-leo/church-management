FROM php:8.3-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl zip unzip libonig-dev libxml2-dev libzip-dev sqlite3 libsqlite3-dev \
    && docker-php-ext-install pdo pdo_mysql pdo_sqlite zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy project files
COPY . .

# Install Laravel dependencies
RUN composer install

# Set Laravel permissions
RUN chmod -R 755 storage
RUN cp .env.example .env
RUN php artisan key:generate

# Expose port and start Laravel
EXPOSE 8000
CMD php artisan serve --host=0.0.0.0 --port=8000
