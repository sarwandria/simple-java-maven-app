FROM amazoncorretto:11-alpine
LABEL maintainer="sarwandria@gmail.com"

RUN apk --no-cache add bash curl unzip
RUN addgroup -S app1 && adduser -S app1 -G app1
RUN mkdir -p /app
RUN chown app1:app1 /app

USER app1:app1

ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} /app/java-maven.jar
WORKDIR /app
EXPOSE 8083
ENTRYPOINT ["java","-jar","java-maven.jar"]