[
  {
    "name": "${airflow_webserver_container_name}",
    "image": "${airflow_image}",
    "cpu": 512,
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
    ],
    "mountPoints": [
      {
        "containerPath": "${airflow_home_folder}",
        "sourceVolume": "${volume_name}"
      }
    ]
  },
  {
    "name": "airflow-scheduler",
    "image": "${airflow_image}",
    "cpu": 512,
    "memory": 2048,
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${log_group}",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs/airflow-scheduler"
        }
    },
    "mountPoints": [
      {
        "containerPath": "${airflow_home_folder}",
        "sourceVolume": "${volume_name}"
      }
    ]
  },
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
        "containerPath": "/home/jovyan",
        "sourceVolume": "${volume_name}"
      }
    ]
  }
]
