Content-Type: multipart/mixed; boundary="==BOUNDARY=="
MIME-Version: 1.0

--==BOUNDARY==
Content-Type: text/cloud-boothook; charset="us-ascii"

# Install amazon-efs-utils
cloud-init-per once yum_update yum update -y
cloud-init-per once install_amazon-efs-utils yum install -y amazon-efs-utils

# Create /efs folder
cloud-init-per once mkdir_efs mkdir /efs

# Mount /efs
cloud-init-per once mount_efs echo -e '${efs_id}:/ /efs efs defaults,_netdev 0 0' >> /etc/fstab
mount -a

--==BOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
# Set any ECS agent configuration options
echo "ECS_CLUSTER=${cluster_name}" >> /etc/ecs/ecs.config

mkdir -p /efs/${user_name}/dags
chown -R 1000:1000 /efs

--==BOUNDARY==--
