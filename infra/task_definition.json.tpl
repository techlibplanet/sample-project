[
  {
    "essential": true,
    "memory": 1024,
    "name": "quizzer-service",
    "cpu": 256,
    "executionRoleArn": "arn:aws:iam::786054985583:role/default-quizzer-ecs-instance-role",
    "image": "786054985583.dkr.ecr.us-east-1.amazonaws.com/sample-project-repo:72eeb86ec682d1b824f927491179ec35b7ae60bb",
{*    "repositoryCredentials": {*}
{*        "credentialsParameter": "arn:aws:secretsmanager:us-east-1:786054985583:secret:GITHUB_READ_PACKAGE_2-KoaDRy"*}
{*    },*}
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