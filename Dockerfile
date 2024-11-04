# Stage 1: Build the application
FROM maven:3.8.4-openjdk-11-slim AS build

WORKDIR /app

# Copy the Maven configuration file and source code
COPY pom.xml .
COPY src ./src

# Build the application, skipping tests
RUN mvn clean package -DskipTests

# Stage 2: Run the application using a minimal base image
FROM gcr.io/distroless/java11-debian11

WORKDIR /app

# Copy the built jar file from the build stage
COPY --from=build /app/target/*.jar ./app.jar

# Expose the application's port
EXPOSE 8080

# Set the entrypoint and default command to run the jar
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
CMD ["--server.port=8080"]


