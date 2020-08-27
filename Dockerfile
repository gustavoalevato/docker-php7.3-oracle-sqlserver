FROM debian:buster

ADD files /tmp/files

RUN apt update -y \
&& apt upgrade -y \
&& apt install -y gnupg2 wget \
&& apt -y install lsb-release apt-transport-https ca-certificates  \
&& wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - \
&& echo "deb https://packages.sury.org/php/ buster main" | tee /etc/apt/sources.list.d/php.list \
&& apt update -y \
&& apt upgrade -y \
&& apt-get install -y apache2 \
&& apt-get install -y php7.3 \
&& apt-get install -y php7.3-cli php7.3-common php7.3-curl php7.3-gd php7.3-json php7.3-mbstring php7.3-mysql php7.3-xml \
&& apt-get install -y php7.3-dev php7.3-soap php7.3-gd php7.3-zip php7.3-ldap php7.3-xdebug \
&& apt-get install -y nano curl zip alien wget 

RUN cd /tmp/files \
&& cd /tmp/files && alien -i oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm \
&& cd /tmp/files && alien -i oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm \
&& cd /tmp/files && alien -i oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm \
&& apt-get install -y libaio1 re2c openssl \
&& echo "/usr/lib/oracle/12.1/client64/lib" >> /etc/ld.so.conf.d/oracle.conf \
&& ldconfig \
&& export ORACLE_HOME=/usr/lib/oracle/12.1/client64/ \
&& mkdir /opt/php7 && cd /opt/php7/ && wget https://github.com/php/php-src/archive/PHP-7.3.zip \
&& unzip /opt/php7/PHP-7.3.zip && cd /opt/php7/php-src-PHP-7.3/ext/pdo_oci/ && phpize \
&& ./configure --with-pdo-oci=instantclient,/usr/lib/oracle/12.1/client64/lib,12.1 \
&& make && printf "\n" | make test -n && printf "\n" \
&& cp /opt/php7/php-src-PHP-7.3/ext/pdo_oci/modules/pdo_oci.so /usr/lib/php/20180731/ \
&& echo "extension=pdo_oci.so" >> /etc/php/7.3/mods-available/pdo_oci.ini \
&& cd /etc/php/7.3/apache2/conf.d && ln -s /etc/php/7.3/mods-available/pdo_oci.ini pdo_oci.ini \
&& cd /etc/php/7.3/cli/conf.d && ln -s /etc/php/7.3/mods-available/pdo_oci.ini pdo_oci.ini \
&& export LD_LIBRARY_PATH64=/usr/lib/oracle/12.1/client64/lib \
&& export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib \
&& a2enmod rewrite && service apache2 restart \
&& wget https://phar.phpunit.de/phpunit.phar && chmod +x phpunit.phar && mv phpunit.phar /usr/local/bin/phpunit 

RUN apt-get update -y
RUN apt-get install php7.3-sybase -y 


ENTRYPOINT [bash, -c, "service apache2 restart && tail -f /dev/null"]