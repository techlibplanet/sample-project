{
"executionRoleArn": "arn:aws:iam::786054985583:role/default-quizzer-ecs-instance-role",
"containerDefinitions": [{
"logConfiguration": {
"logDriver": "awslogs",
"secretOptions": null,
"options": {
"awslogs-group": "${CLOUDWATCH_GROUP}",
"awslogs-region": "us-east-1",
"awslogs-stream-prefix": "ecs"
}
},
"portMappings": [{
"hostPort": 8080,
"protocol": "tcp",
"containerPort": 8080
}],
"repositoryCredentials": {
"credentialsParameter": "arn:aws:secretsmanager:us-east-1:786054985583:secret:GITHUB_READ_PACKAGE_1-NehK1l"
},
"image": "ghcr.io/techlibplanet/sample-project:latest",
"essential": true,
"name": "quizzer_service"
}],
"memory": 1024,
"taskRoleArn": "arn:aws:iam::786054985583:role/default-quizzer-ecs-instance-role",
"compatibilities": [
"EC2",
"FARGATE"
],
"requiresCompatibilities": [
"FARGATE"
],
"cpu": "256"
}