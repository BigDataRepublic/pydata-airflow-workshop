[
  {
    "name": "${jupyter_container_name}",
    "image": "${jupyter_image}",
    "cpu": 512,
    "memory": 1024,
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${log_group}",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs/jupyter"
        }
    },
    "portMappings": [
      {
        "containerPort": ${jupyter_port},
        "hostPort": ${jupyter_port}
      }
    ],
    "mountPoints": [
      {
        "containerPath": "/home/jovyan/dags",
        "sourceVolume": "${dags_volume_name}",
        "readOnly": false
      }
    ]
  }
]
