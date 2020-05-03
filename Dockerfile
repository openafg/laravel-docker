FROM php:7.2-fpm

LABEL maintainer="Mohammad Rahmani <rto1680@gmail.com>"

RUN apt-get update
RUN apt install -y apt-utils

# Install dependencies
RUN apt-get install -qq -y \
  curl \
  git \
  zlib1g-dev \
  zip unzip

RUN apt install -y libmcrypt-dev libicu-dev libxml2-dev
RUN apt-get install -y libjpeg-dev libpng-dev libfreetype6-dev libjpeg62-turbo-dev
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ 
RUN docker-php-ext-install gd 

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions     
RUN docker-php-ext-install \
  bcmath \
  pdo_mysql \
  pcntl \
  zip \
  pdo \
  ctype \
  mbstring \
  tokenizer \
  fileinfo \
  xml \
  intl

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY . /var/www

WORKDIR /var/www

RUN chown -R www-data:www-data \
  /var/www/storage \
  /var/www/bootstrap/cache \
  /var/www/node_modules

CMD php-fpm
