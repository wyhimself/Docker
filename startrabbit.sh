#!/bin/bash
/usr/sbin/rabbitmq-server & rabbitmqctl wait /var/lib/rabbitmq/mnesia/rabbit\@$HOSTNAME.pid
echo "Removing 'guest' user and adding ${RABBITMQ_S_USER} && ${RABBITMQ_C_USER}"
rabbitmqctl delete_user guest
rabbitmqctl add_vhost $RABBITMQ_VHOST
rabbitmqctl add_user $RABBITMQ_S_USER $RABBITMQ_S_PASS
rabbitmqctl add_user $RABBITMQ_C_USER $RABBITMQ_C_PASS
rabbitmqctl set_user_tags $RABBITMQ_S_USER administrator
rabbitmqctl set_permissions -p $RABBITMQ_VHOST $RABBITMQ_S_USER ".*" ".*" ".*"
rabbitmqctl set_permissions -p $RABBITMQ_VHOST $RABBITMQ_C_USER "" ".*" ".*"
tail -f /var/log/rabbitmq/rabbit\@$HOSTNAME.log