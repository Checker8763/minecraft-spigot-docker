# Docker image for Minecraft Spigot Server
## Run the Image

`docker run -dit -p {PORT_ON_YOUR_MACHINE}:25565 --name spigot checker8763/spigot`

-dit
: -d run with detached console, -i interactive otherwise you can not write to console, -t something with tty that is recommended

-p {PORT_ON_YOUR_MACHINE}:25565
: open the port for access to the server, can be the same as the container one or another

### Example Docker-Compose

```dockerfile
version: '2.4'
services:
    spigot:
        image: checker8763/spigot
        container_name: spigot
        ports:
            #Game Port
            - "{PORT_ON_YOUR_MACHINE}:25565"
            # OPTIONAL: only if you use rcon -> needs rcon enabled
            - "{PORT_ON_YOUR_MACHINE}:25575"
        volumes:
            # with a volume
            - "{VOLUME_NAME}:/home/spigot"
            # Or with bindmound
            - "{PATH_TO_FOLDER}:/home/spigot"
volumes:
    {VOLUME_NAME}: {}
```


## Access the console

`docker attach -it spigot`

To detach without stopping press:
CTRL-P CTRL-Q

Thats the standard shortcut by docker

## Build it yourself

1. Clone this repo
2. Switch to the newly created folder
3. Build by executing `docker build --build-arg SPIGOT_VERSION={INSERT_VERSION} --force-rm -q -t spigot:{INSERT_VERSION} .`

"--build-arg SPIGOT_VERSION={INSERT_VERSION}"
: set the spigot version that should be built

"--force-rm"
: always remove intermediate containers

"-q"
: no text output

"-t spigot:{INSERT_VERSION}"
: the tag for the created image

### Build fails
Remove intermediate images:

**This will remove every unused image!!!**

`docker image prune -f`

### Build inside a screen
**For experienced people**

You can build the image inside a screen so you can log off.
Only use if you are familliar with the  screen command.

1. `cd /server/Docker/Spigot`
2. `screen -S dockerbuild docker build --build-arg SPIGOT_VERSION={INSERT_VERSION} --force-rm -q -t spigot:{INSERT_VERSION} .`