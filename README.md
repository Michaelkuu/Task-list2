docker compose up -d --build

cd ścieżka/do/projektu/Task-list2/src  
sudo composer install

docker-compose exec app php artisan db:seed
