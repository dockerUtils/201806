FROM php:apache

RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && apt-get update -y && apt-get upgrade -y; \
    apt-get install -y wget zlib1g-dev nano; \
    cd ~ \
    && wget https://nih.at/libzip/libzip-1.2.0.tar.gz \ 
    && tar -zxf libzip-1.2.0.tar.gz \
    && cd libzip-1.2.0 \
    && ./configure && make && make install; \
    \
    apt-get install -y libzip-dev; \
    \
    ln -s /usr/local/lib/libzip/include/zipconf.h /usr/local/include; \
    \
    wget http://pecl.php.net/get/zip-1.15.3.tgz \
    && tar zxf zip-1.15.3.tgz && cd zip-1.15.3 \
    && phpize && ./configure --with-php-config=/usr/local/bin/php-config \
    && make && make install; \
    \
    ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load; \
    \
    cd ~; \
    wget https://github.com/phpredis/phpredis/archive/4.0.2.tar.gz; \
    tar -zxf 4.0.2.tar.gz; \
    cd phpredis-4.0.2; \
    phpize && ./configure --with-php-config=/usr/local/bin/php-config; \
    make && make install; \
    \
    docker-php-ext-install mysqli pdo pdo_mysql; \
    { \
    echo "extension=redis.so"; \
    # echo "extension=/root/libzip-1.2.0/zip-1.15.2/modules/zip.so"; \
    echo "extension=zip.so"; \
    echo "zlib.output_compression = On"; \
    } >> /usr/local/etc/php/php.ini

RUN cd ~ && curl -sS https://getcomposer.org/installer | php \
    && cp composer.phar /usr/local/bin/composer; \
    composer config -g repo.packagist composer https://packagist.phpcomposer.com; \
    composer global require "laravel/installer"; \
    echo "export PATH=$HOME/.composer/vendor/bin:$PATH" >> /root/.bashrc; \
    rm -rf ~/*
    
ENTRYPOINT ["docker-php-entrypoint"]
CMD ["apache2-foreground"]
