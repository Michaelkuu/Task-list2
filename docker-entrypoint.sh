#!/bin/sh
set -e

# Kopiowanie .env jeśli nie istnieje
if [ ! -f .env ]; then
    cp .env.example .env
fi

# Generowanie klucza aplikacji jeśli nie istnieje
if [ -z "$(grep '^APP_KEY=' .env)" ] || [ "$(grep '^APP_KEY=' .env | cut -d'=' -f2)" = "" ]; then
    php artisan key:generate
fi

# Przygotowanie bazy danych
if [ ! -f database/database.sqlite ]; then
    mkdir -p database
    touch database/database.sqlite
fi

# Ustawienie uprawnień
chown -R www-data:www-data \
    storage \
    bootstrap/cache \
    database

chmod -R 775 \
    storage \
    bootstrap/cache \
    database

# Migracje
php artisan migrate --force
# php artisan db:seed --force

# Uruchomienie PHP-FPM
php-fpm