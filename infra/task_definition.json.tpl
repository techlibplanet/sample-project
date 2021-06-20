[
  {
    "essential": true,
    "memory": 1024,
    "name": "quizzer-service",
    "cpu": 256,
    "image": "ghcr.io/techlibplanet/sample-project:latest",
    "secrets": [{
      "name": "default",
      "valueFrom": "arn:aws:secretsmanager:us-east-1:786054985583:secret:GITHUB_READ_PACKAGE"
    }],
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