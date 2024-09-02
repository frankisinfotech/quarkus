# Stage 1: Build the application
FROM maven:3.8.3-openjdk-17 AS build

# Set the working directory
WORKDIR /workspace

#Increase Maven's Heap Size
ENV MAVEN_OPTS="-Xmx512m -XX:MaxMetaspaceSize=128m"

# Copy the Maven build files
COPY pom.xml ./

# Copy the source code
COPY src ./src

# Package the application
RUN mvn package -DskipTests

RUN ls -l /workspace

# Stage 2: Create the final image
FROM openjdk:17-jdk-slim 


# Set the working directory
WORKDIR /app

# Copy the Quarkus build output from the build stage
#COPY --from=build /workspace/target/lib/ /app/lib/
COPY --from=build /workspace/target/*.jar /app

# Expose the application port
EXPOSE 8080

# Set the default command to run the application
CMD ["java", "-jar", "/app/hoptool-auth-service-1.0.0-SNAPSHOT-runner.jar"]
