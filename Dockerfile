FROM openjdk:16
ADD target/sample-project-0.0.1-SNAPSHOT.jar sample-project-0.0.1-SNAPSHOT.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "sample-project-0.0.1-SNAPSHOT.jar"]
