FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app
COPY target/java-docker-demo-1.0.jar app.jar
EXPOSE 8090
CMD ["java", "-cp", "app.jar", "com.example.App"]