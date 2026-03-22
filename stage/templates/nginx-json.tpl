[
  {
    "name": "${app_prefix}-nginx",
    "image": "nginx:latest",
    "cpu": 256,
    "memory": 512,
    "networkMode": "awsvpc",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/${app_prefix}/nginx",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "linuxParameters": {
      "initProcessEnabled": true
    },
    "enableExecuteCommand": true
  }
]
