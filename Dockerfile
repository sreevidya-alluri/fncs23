FROM centos:7

#change repo from mirror list to vault
RUN sed -i 's/^mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Base.repo && \
    sed -i 's|^#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Base.repo && \
    yum clean all && \
    yum -y update
 
RUN yum -y install vim


RUN yum -y install epel-release && \
    yum -y install nginx java-1.8.0-openjdk wget redis && \
    yum -y install php php-bcmath php-cli php-common php-gd php-intl php-ldap php-mbstring \
                   php-mysqlnd php-pear php-soap php-xml php-xmlrpc php-zip && \
    yum clean all

RUN yum -y install  curl 
 
RUN wget https://downloads.apache.org/kafka/3.9.1/kafka_2.13-3.9.1.tgz && \
    tar -xzf kafka_2.13-3.9.1.tgz -C /opt && \
    mv /opt/kafka_2.13-3.9.1 /opt/kafka && \
    rm -f kafka_2.13-3.9.1.tgz


# Copy main nginx.conf to /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

# Copy default server block to /etc/nginx/conf.d/
COPY default.conf /etc/nginx/conf.d/default.conf

# Copy website content to /var/www/html/
COPY index.html /var/www/html/index.html

COPY phpinfo.php /var/www/html/phpinfo.php

RUN  yum install -y  php-fpm


EXPOSE 80 

COPY start.sh /start.sh
RUN chmod +x /start.sh


ENTRYPOINT ["/start.sh"]
