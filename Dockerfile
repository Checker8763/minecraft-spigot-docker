FROM openjdk:8-jre-alpine AS builder
ARG SPIGOT_VERSION=1.15.2

WORKDIR /home/build

RUN wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar && \
	apk add git
RUN java -Xmx1G -jar BuildTools.jar -rev ${SPIGOT_VERSION}

#############################################################################################

FROM openjdk:8-jre-alpine

LABEL maintainer="Tomek Kochanowsky <tomkocha@gmail.com>"

ARG SPIGOT_VERSION=1.15.2
ARG RCON_PASS=SpigotAdmin

WORKDIR /home/spigot

#Get the server.jar
COPY --from=builder /home/build/spigot-${SPIGOT_VERSION}.jar ./server.jar

RUN echo "eula=true" > eula.txt && \
	echo "enable-rcon=true" >> server.properties && \
	echo rcon.password=${RCON_PASS} >> server.properties && \
	adduser -S -H -u 1001 spigot && \
	chown -R spigot /home/spigot

# Run as spigot user for safety
USER spigot
# Standard Server Port
EXPOSE 25565
# Rcon Port
EXPOSE 25575
# Regulate the Ram and Cpu via Docker Container
CMD java -jar /home/spigot/server.jar
