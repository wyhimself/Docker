# Docker file for rabbitmq single or cluster from bolingcavalry 
# VERSION 0.0.3
# Author: bolingcavalry

#基础镜像
FROM centos:7

#作者
MAINTAINER BolingCavalry <zq2599@gmail.com>

#定义时区参数
ENV TZ=Asia/Shanghai

#设置时区
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo '$TZ' > /etc/timezone

#设置编码为中文
RUN yum -y install kde-l10n-Chinese glibc-common

RUN localedef -c -f UTF-8 -i zh_CN zh_CN.utf8

ENV LC_ALL zh_CN.utf8 

#安装wget工具
RUN yum install -y wget unzip tar

#安装erlang
RUN rpm -Uvh http://47.104.216.250:10713/file/erlang-22.2.8-1.el7.x86_64.rpm

RUN yum install -y erlang

#安装rabbitmq
RUN rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc

RUN yum install -y http://47.104.216.250:10713/file/rabbitmq-server-3.8.2-1.el7.noarch.rpm

RUN /usr/sbin/rabbitmq-plugins list <<<'y'

#安装常用插件
RUN /usr/sbin/rabbitmq-plugins enable --offline rabbitmq_mqtt rabbitmq_stomp rabbitmq_management  rabbitmq_management_agent rabbitmq_federation rabbitmq_federation_management <<<'y'

#添加配置文件
ADD rabbitmq.config /etc/rabbitmq/

#添加启动容器时执行的脚本，主要根据启动时的入参做集群设置
ADD startrabbit.sh /opt/rabbit/

#给相关资源赋予权限
RUN chmod u+rw /etc/rabbitmq/rabbitmq.config \
&& mkdir -p /opt/rabbit \
&& chmod a+x /opt/rabbit/startrabbit.sh

#暴露常用端口
EXPOSE 5672
EXPOSE 15672
EXPOSE 25672

#设置容器创建时执行的脚本
CMD /opt/rabbit/startrabbit.sh