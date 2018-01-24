# Smartbox Docker для проектов на Symfony 4

## Что входит в комплект

* [nginx](https://nginx.org/)
* [PHP-FPM](https://php-fpm.org/)
* [MySQL](https://www.mysql.com/)
* [PHPMyAdmin](https://www.phpmyadmin.net/)

## Пред установкой

Необходимы уставноленные [docker](https://www.docker.com/) и [docker-compose](https://docs.docker.com/compose/) и утилита [GNU make](https://www.gnu.org/software/make/manual/make.html).

## Уставнока

1. Создайте файл `.env` из `.env.dist` и настройте его в соотвествии с вашими настройками

    ```sh
    $ cp .env.dist .env && EDITOR .env
    ```

2. Сборка и запуск контейнеров выполняются коммандами

    ```sh
    $ make build
    $ make start
    ```
    Или альтернативные комманды
    
    ```sh
    $ docker-compose build
    $ docker-compose up -d
    ```

3. Обновите ваш hosts файл (Выпольнить только один раз)

    ```sh
    # Получить IP адресс моста и обновить hosts файл 
    $ sudo echo $(docker network inspect bridge | grep Gateway | grep -o -E '[0-9\.]+') "symfony.dev" >> /etc/hosts
    # ИЛИ альтернативная комманда
    $ ifconfig docker0 | awk '/inet:/{ print substr($2,6); exit }'
    ```

4. Подготовка Symfony приложения
    
   1. Запустите `composer install` и создайте базу данных в контейнере

      ```sh
      $ docker-compose exec php bash
      $ composer install
      $ symfony doctrine:database:create
      $ symfony doctrine:schema:update --force
      ```
5. (Опционально) Xdebug: Настройте вашу IDE для соединения по порту `9001` с ключом `PHPSTORM`

## Как это работает?

У нас есть следующие образы для создания контенеров с помощью `docker-compose build`

* `nginx`: Контейнер веб-сервера Nginx, в котором смонтирован Symfony проект.
* `php`: PHP-FPM контейнер в котором так же смонтирован Symfony проект.
* `mysqldb`: MySQL базаданных в конетнере.

Запуск `docker-compose ps` или `make ps` должен вывести результат с запущеними контейнерами:

```text
        Name                      Command              State                     Ports                    
---------------------------------------------------------------------------------------------------------
container_mysql        docker-entrypoint.sh mysqld     Up      0.0.0.0:3307->3306/tcp                     
container_nginx        nginx                           Up      0.0.0.0:443->443/tcp, 0.0.0.0:8000->80/tcp 
container_phpfpm       docker-php-entrypoint php-fpm   Up      0.0.0.0:9000->9000/tcp                     
container_phpmyadmin   /run.sh phpmyadmin              Up      0.0.0.0:8080->80/tcp 
```

## Ипользование

Дополнительную справку по коммандам см. в `make help` или в официальной документации [docker](https://www.docker.com/) и [docker-compose](https://docs.docker.com/compose/)
Как только все контейнеры будут готовы, наши услуги доступны по адресу:
* Symfony app: [symfony.dev:8000](http://symfony.dev:8000)
* PHPMyAdmin: [symfony.dev:8080](http://symfony.dev:8080)
* Log файлы размещены по адресу: *logs/nginx* and *logs/symfony*
