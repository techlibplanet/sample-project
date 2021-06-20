[
  {
    "essential": true,
    "memory": 1024,
    "name": "quizzer-service",
    "cpu": 256,
    "containerDefinitions": [
      {
        "image": "ghcr.io/techlibplanet/sample-project:latest",
        "secrets": [
          {
            "name": "GITHUB_READ_PACKAGE_1",
            "valueFrom": "arn:aws:secretsmanager:us-east-1:786054985583:secret:GITHUB_READ_PACKAGE_1-NehK1l"
          }
        ]
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