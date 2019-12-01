FROM sum3dh/php7.2-apache:ospos

MAINTAINER SumedhBG

RUN a2enmod rewrite

RUN echo "date.timezone = \"\${PHP_TIMEZONE}\"" > /usr/local/etc/php/conf.d/timezone.ini
RUN echo -e “$(hostname -i)\t$(hostname) $(hostname).localhost” >> /etc/hosts

CMD curl -L https://github.com/a8m/envsubst/releases/download/v1.1.0/envsubst-`uname -s`-`uname -m` -o envsubst \
    chmod +x envsubst \
    sudo mv envsubst /usr/local/bin

WORKDIR /app
COPY . /app
RUN ln -s /app/*[^public] /var/www && rm -rf /var/www/html && ln -nsf /app/public /var/www/html
RUN chmod 755 /app/public/uploads && chown -R www-data:www-data /app/public /app/application

RUN [ ! -f test/ospos.js ] || sed -i -e "s/\(localhost\)/web/g" test/ospos.js

