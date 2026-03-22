[
  {
    "name": "${app_prefix}-internal-tool",
    "image": "${app_image}",
    "cpu": ${cpu},
    "memory": ${memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/${app_prefix}/internal-tool",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "portMappings": [
      {
        "containerPort": ${port},
        "hostPort": ${port}
      }
    ],
    "linuxParameters": {
      "initProcessEnabled": true
    },
    "enableExecuteCommand": true
  }
]
