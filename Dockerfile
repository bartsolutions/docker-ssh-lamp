#WARNING: Replace all '<CHANGE-ME>' to the actual passwords you want
FROM ubuntu:14.04
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

RUN apt-get -y install apache2 

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server 

RUN apt-get -y install php5 libapache2-mod-php5 php5-mcrypt



#Set up SSH access
RUN mkdir /var/run/sshd
RUN sed -i.bak s/PermitRootLogin\ without-password/PermitRootLogin\ yes/g  /etc/ssh/sshd_config
RUN echo "root:$sshpass" | chpasswd


COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf


EXPOSE 22 80 3306 

CMD ["/usr/bin/supervisord"]

VOLUME ["/var/lib/mysql", "/var/log/mysql", "/var/log/apache2"]
