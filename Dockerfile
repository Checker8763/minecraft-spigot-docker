#Building Stage
FROM openjdk:8-jre-alpine AS builder
ARG SPIGOT_VERSION=1.15.2

WORKDIR /home/build

RUN wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar && \
	apk add git
RUN java -Xmx1G -jar BuildTools.jar -rev ${SPIGOT_VERSION}


#Production Stage
FROM openjdk:8-jre-alpine

LABEL maintainer="Tomek Kochanowsky <tomkocha@gmail.com>"

ARG SPIGOT_VERSION=1.15.2

WORKDIR /home/spigot

# Run as spigot user for safety
RUN adduser -S spigot
USER spigot

COPY --from=builder /home/build/spigot-${SPIGOT_VERSION}.jar ./server.jar
RUN echo "eula=true" > eula.txt
# Standard Server Port
EXPOSE 25565
# Rcon Port
EXPOSE 25575
# Regulate the Ram and Cpu via Docker Container
CMD java -Xms128m -jar /home/spigot/server.jar nogui 
