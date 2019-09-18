#!/bin/bash
yum -y install gcc pcre-devel openssl-devel
tar -xf lnmp_soft.tar.gz
cd lnmp_soft
tar -xf nginx-1.12.2.tar.gz
cd nginx-1.12.2
./configure --with-http_ssl_module
make && make install
yum -y install  mariadb  mariadb-server  mariadb-devel
yum install -y php php-mysql php-fpm

sed -i '65,72s/#//' /usr/local/nginx/conf/nginx.conf
sed -i '/SCRIPT_FILENAME/d' /usr/local/nginx/conf/nginx.conf
sed -i 's/fastcgi_params/fastcgi.conf/' /usr/local/nginx/conf/nginx.conf

/usr/local/nginx/sbin/nginx
netstat -utnlp | grep :80
systemctl start mariadb php-fpm

