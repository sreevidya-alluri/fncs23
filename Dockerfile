FROM centos:7


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


RUN sed -i 's|root /usr/share/nginx/html;|root /var/www/html;|' /etc/nginx/nginx.conf 
COPY default.conf /etc/nginx/conf.d/default.conf



RUN echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php



RUN wget https://downloads.apache.org/kafka/3.9.1/kafka_2.13-3.9.1.tgz && \
    tar -xzf kafka_2.13-3.9.1.tgz -C /opt && \
    mv /opt/kafka_2.13-3.9.1 /opt/kafka && \
    rm -f kafka_2.13-3.9.1.tgz


WORKDIR /opt/kafka

EXPOSE 80 9092 2181


CMD ["nginx", "-g", "daemon off;"]

