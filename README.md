# Docker Images for Laravel Development

This repository provides you a development environment without requiring you to install PHP, a web server, and any other server software on your local machine. For this, it requires Docker and Docker Compose.

## Installation

1. Install [docker](https://docs.docker.com/engine/installation/) and [docker-compose](https://docs.docker.com/compose/install/).

2. Copy `docker-compose.yml` file to your project root path, and edit it according to your needs.

3. From your project directory, start up your application by running:

```sh
docker-compose up
```
4. You can run `composer` or `npm` or `artisan` through docker. For instance:

```sh
docker-compose exec app composer install
docker-compose exec app php artisan migrate
docker-compose exec npm $yourCommandHere
```
But I have already provided a `script.sh` command line tool that helps us run our commands easily:
```sh
bash script.sh -a "migrate" # This command can run php artisan migrate
bash script.sh -c "require 'package-name'" # Install composer package
```
## Customize Docker Images

These docker images are configured in `docker-compose.yml` file 
and also the production version is `docker-compose.production.yml`.

If you're not using Vuejs with your Laravel application, you can simply comment the `npm` container.
```
npm:
    container_name: npm
    image: node:14.1.0-slim
    command: /bin/bash "/var/www/commands/development/start-npm.sh"
    volumes: 
      - ./:/var/www
    networks: 
      - application-network
```
## MySQL Configuration
This is a simple environment configuration I have provided in `docker-compose.yml` file:
```
environment:
      MYSQL_DATABASE: laravel
      MYSQL_ROOT_PASSWORD: password
```
But you can add more configurations to your MySQL by adding:
```
environment:
      MYSQL_DATABASE: 'laravel'
      MYSQL_USER: 'laravel-user'
      MYSQL_PASSWORD: 'laravel@123'
      MYSQL_ROOT_PASSWORD: 'root@123'
```
## Deployment
When you're ready to deploy your Laravel application to production, there are some important things you can do to make sure your application is running as efficiently as possible.
Read [this doc](https://laravel.com/docs/7.x/deployment) to prepare your project. But I have provided the `nginx` configuration in two diffrent environments, `development` and `production`, and also I have enabled the caching server and gzip in `nginx`.
```
server {
    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_buffers 16 8k;
    gzip_http_version 1.1;
    gzip_min_length 256;
    gzip_types text/plain text/css application/json application/javascript application/x-javascript text/xml application/xml application/xml+rss text/javascript application/vnd.ms-fontobject application/x-font-ttf font/opentype image/svg+xml image/x-icon;

    client_max_body_size 20M;
    listen 80;
    server_name server.dev;
    index index.php index.html;
    error_log  /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;
    root /var/www/public;

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;

        # app is our php container
        fastcgi_pass app:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    # ----------------------------------------------------------------------
    # Expire rules for static content
    # ----------------------------------------------------------------------
    
    # cache.appcache, your document html and data
    location ~* \.(?:manifest|appcache|html?|xml|json)$ {
        expires -1;
    }

    # Feed
    location ~* \.(?:rss|atom)$ {
        expires 1h;
        add_header Cache-Control "public";
    }

    # Media: images, icons, video, audio, HTC
    location ~* \.(?:jpg|jpeg|gif|png|cur|gz|svgz|mp4|ogg|ogv|webm|htc)$ {
        expires 1M;
        access_log off;
        add_header Cache-Control "public";
    }

    # CSS and Javascript
    location ~* \.(?:css|js|ico|woff|eot|svg|ttf|otf)$ {
        expires 1y;
        access_log off;
        add_header Cache-Control "public";
    }
}
```

## Contributing

Contributions are very welcome!
Leave an issue on Github, or create a Pull Request.

## Licence

[MIT](LICENCE) licence.
