[
  {
    "name": "jupyter",
    "image": "bdrci/pydata-2019-jupyter",
    "cpu": 1024,
    "memory": 2048,
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
    ],
    "environment": [
      {
        "name": "WORKSHOP_USER",
        "value": "${user_name}"
      },
      {
        "name": "WORKSHOP_PASSWORD",
        "value": "${password}"
      }
    ]
  }
]
