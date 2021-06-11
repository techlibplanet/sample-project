[
  {
    "essential": true,
    "memory": 1024,
    "name": "quizzer-service",
    "cpu": 256,
    "image": "${REPOSITORY_URL}:latest",
    "environment": [
      {
        "name": "SPRING_DATASOURCE_URL",
        "value": "${SPRING_DATASOURCE_URL}"
      }
    ],
    "portMappings": [
      {
        "containerPort": 8080
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${CLOUDWATCH_GROUP}",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]