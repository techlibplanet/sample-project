[
  {
    "essential": true,
    "memory": 1024,
    "name": "quizzer-service",
    "cpu": 256,
    "executionRoleArn": "arn:aws:iam::786054985583:role/default-quizzer-ecs-instance-role",
    "image": "ghcr.io/techlibplanet/sample-project:latest",
    "repositoryCredentials": {
        "credentialsParameter": "arn:aws:secretsmanager:us-east-1:786054985583:secret:GITHUB_READ_PACKAGE_1-NehK1l"
    },
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