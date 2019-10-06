[
  {
    "name": "${airflow_webserver_container_name}",
    "image": "${airflow_image}",
    "cpu": 1024,
    "memory": 1024,
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${log_group}",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs/airflow-webserver"
        }
    },
    "portMappings": [
      {
        "containerPort": ${airflow_port},
        "hostPort": ${airflow_port}
      }
    ]
  },
  {
    "name": "${jupyter_container_name}",
    "image": "${jupyter_image}",
    "cpu": 2048,
    "memory": 5632,
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
    ]
  }
]
