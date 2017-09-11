FROM harbor.sh.zts.com.cn/base/gocron:latest

MAINTAINER chenwenwen <chenww01@zts.com.cn>

WORKDIR /application

RUN wget https://sourceforge.net/projects/pentaho/files/Data%20Integration/5.0.1-stable/pdi-ce-5.0.1-stable.zip -O kettle5.0.1.zip &&\
    unzip kettle5.0.1.zip && \
    rm -rf kettle5.0.1.zip

RUN wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.35.tar.gz && \
    tar -xzf mysql-connector-java-5.1.35.tar.gz -C /application/data-integration/lib && \
    rm -rf mysql-connector-java-5.1.35.tar.gz
 
RUN mkdir /application/simple-jndi && \
    cp -f /usr/share/zoneinfo/PRC /etc/localtime

ADD conf/ /application/
ADD scripts/*.sh /application/
ADD simple-jndi/ /application/simple-jndi 

CMD ["/application/start.sh"]
