#WARNING: Replace all '<CHANGE-ME>' to the actual passwords you want
FROM ubuntu:16.04
USER root

#set up your password here
ARG sshpass=<CHANGE_ME>

WORKDIR /root


#Install basic environment
RUN apt-get -y update && \
    apt-get -y install \
	subversion \ 
    openssh-server \
	supervisor \
    vim


RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server 

RUN apt-get install -y \
	php7.0 \
	php7.0-bz2 \
	php7.0-cgi \
	php7.0-cli \
	php7.0-common \
	php7.0-curl \
	php7.0-dev \
	php7.0-enchant \
	php7.0-fpm \
	php7.0-gd \
	php7.0-gmp \
	php7.0-imap \
	php7.0-interbase \
	php7.0-intl \
	php7.0-json \
	php7.0-ldap \
	php7.0-mcrypt \
	php7.0-mysql \
	php7.0-odbc \
	php7.0-opcache \
	php7.0-pgsql \
	php7.0-phpdbg \
	php7.0-pspell \
	php7.0-readline \
	php7.0-recode \
	php7.0-snmp \
	php7.0-sqlite3 \
	php7.0-sybase \
	php7.0-tidy \
	php7.0-xmlrpc \
	php7.0-xsl \
	command-not-found

RUN apt-get install apache2 libapache2-mod-php7.0 -y


#Set up SSH access
RUN mkdir /var/run/sshd
RUN sed -i.bak s/PermitRootLogin\ prohibit-password/PermitRootLogin\ yes/g  /etc/ssh/sshd_config
RUN echo "root:$sshpass" | chpasswd


COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf


EXPOSE 22 80 3306 

CMD ["/usr/bin/supervisord"]

VOLUME ["/var/lib/mysql", "/var/log/mysql", "/var/log/apache2"]
