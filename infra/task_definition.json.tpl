{
"ipcMode": null,
"executionRoleArn": "arn:aws:iam::786054985583:role/default-quizzer-ecs-instance-role",
"containerDefinitions": [
{
"dnsSearchDomains": null,
"environmentFiles": null,
"logConfiguration": {
"logDriver": "awslogs",
"secretOptions": null,
"options": {
"awslogs-group": "/ecs/quizzer_service",
"awslogs-region": "us-east-1",
"awslogs-stream-prefix": "ecs"
}
},
"entryPoint": null,
"portMappings": [
{
"hostPort": 8080,
"protocol": "tcp",
"containerPort": 8080
}
],
"command": null,
"linuxParameters": null,
"cpu": 0,
"environment": [],
"resourceRequirements": null,
"ulimits": null,
"repositoryCredentials": {
"credentialsParameter": "arn:aws:secretsmanager:us-east-1:786054985583:secret:GITHUB_READ_PACKAGE_1-NehK1l"
},
"dnsServers": null,
"mountPoints": [],
"workingDirectory": null,
"secrets": null,
"dockerSecurityOptions": null,
"memory": null,
"memoryReservation": null,
"volumesFrom": [],
"stopTimeout": null,
"image": "ghcr.io/techlibplanet/sample-project:latest",
"startTimeout": null,
"firelensConfiguration": null,
"dependsOn": null,
"disableNetworking": null,
"interactive": null,
"healthCheck": null,
"essential": true,
"links": null,
"hostname": null,
"extraHosts": null,
"pseudoTerminal": null,
"user": null,
"readonlyRootFilesystem": null,
"dockerLabels": null,
"systemControls": null,
"privileged": null,
"name": "quizzer_service"
}
],
"placementConstraints": [],
"memory": "512",
"taskRoleArn": "arn:aws:iam::786054985583:role/default-quizzer-ecs-instance-role",
"compatibilities": [
"EC2",
"FARGATE"
],
"taskDefinitionArn": "arn:aws:ecs:us-east-1:786054985583:task-definition/quizzer-service:19",
"family": "quizzer_service",
"requiresAttributes": [
{
"targetId": null,
"targetType": null,
"value": null,
"name": "com.amazonaws.ecs.capability.logging-driver.awslogs"
},
{
"targetId": null,
"targetType": null,
"value": null,
"name": "ecs.capability.execution-role-awslogs"
},
{
"targetId": null,
"targetType": null,
"value": null,
"name": "com.amazonaws.ecs.capability.docker-remote-api.1.19"
},
{
"targetId": null,
"targetType": null,
"value": null,
"name": "ecs.capability.private-registry-authentication.secretsmanager"
},
{
"targetId": null,
"targetType": null,
"value": null,
"name": "com.amazonaws.ecs.capability.task-iam-role"
},
{
"targetId": null,
"targetType": null,
"value": null,
"name": "com.amazonaws.ecs.capability.docker-remote-api.1.18"
},
{
"targetId": null,
"targetType": null,
"value": null,
"name": "ecs.capability.task-eni"
}
],
"pidMode": null,
"requiresCompatibilities": [
"FARGATE"
],
"networkMode": "awsvpc",
"cpu": "256",
"revision": 1,
"status": "ACTIVE",
"inferenceAccelerators": null,
"proxyConfiguration": null,
"volumes": []
}