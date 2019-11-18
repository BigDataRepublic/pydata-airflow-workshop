#!/bin/bash
# Set any ECS agent configuration options
echo "ECS_CLUSTER=${cluster_name}" >> /etc/ecs/ecs.config

mkdir -p /efs/${user_name}/dags
chown -R 1000:1000 /efs/${user_name}
