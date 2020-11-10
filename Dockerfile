ARG ARCH=
FROM ${ARCH}openjdk:8-jre-alpine AS builder
ARG SPIGOT_VERSION=1.16.3

WORKDIR /home/build

RUN  echo ${SPIGOT_VERSION} && \
	wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar && \
	# git required by the BuildTool
	apk add git && \
	java -Xmx1G -jar BuildTools.jar -rev ${SPIGOT_VERSION}

#############################################################################################
ARG ARCH=
FROM ${ARCH}openjdk:8-jre-alpine

LABEL maintainer="Tomek Kochanowsky <tomkocha@gmail.com>"

ARG SPIGOT_VERSION=1.16.3

WORKDIR /home/spigot

# Accept Eula add spigot user
RUN echo "eula=true" > eula.txt && \
	adduser -D -u 1000 spigot

#Get the server.jar
COPY --from=builder --chown=spigot /home/build/spigot-${SPIGOT_VERSION}.jar ./server.jar
# Run as spigot user for safety and fileownership
USER spigot
# Standard Server Port
EXPOSE 25565 \
# Rcon Port
	25575
# Correctly stop the server
STOPSIGNAL SIGINT
# Regulate the Ram and Cpu via Docker Container
CMD java -jar server.jar
