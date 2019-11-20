[
  {
    "name": "${airflow_webserver_container_name}",
    "image": "${airflow_image}",
    "cpu": 512,
    "memory": 512,
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
        "sourceVolume": "${airflow_volume_name}"
      }
    ],
    "environment": [
        {
          "name": "WORKSHOP_USER",
          "value": "${user_name}"
        },
        {
          "name": "AWS_REGION",
          "value": "${aws_region}"
        },
        ${airflow_env}
    ]
  },
  {
    "name": "airflow-scheduler",
    "image": "${airflow_image}",
    "cpu": 512,
    "memory": 2048,
    "networkMode": "awsvpc",
    "command": ["scheduler"],
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
        "sourceVolume": "${airflow_volume_name}"
      }
    ],
    "environment": [
        {
          "name": "WORKSHOP_USER",
          "value": "${user_name}"
        },
        ${airflow_env}
    ]
  },
  {
    "name": "${jupyter_container_name}",
    "image": "bdrci/pydata-2019-jupyter",
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
    ],
    "environment": [
      {
        "name": "WORKSHOP_USER",
        "value": "${user_name}"
      }
    ]
  }
]
