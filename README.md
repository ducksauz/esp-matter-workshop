# esp-matter-workshop
ESP Matter Workshop for BSides Seattle 2023

## Required software

You'll need some basic dev tools installed on your laptop

* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [Docker](https://docs.docker.com/get-docker/)
* [esptool](https://github.com/espressif/esptool)
* a code editor. I'm using [VS Code](https://code.visualstudio.com/download), but you're free to use whatever

## Check out this workshop repo

```bash
git clone https://github.com/ducksauz/esp-matter-workshop.git
cd esp-matter-workshop
```

## Download the build container

Build containers are a great way to ensure that everyone is working
with the same tooling. They're especially helpful for this build
environment, as there are a lot of dependencies that are a real pain
in the butt to get installed properly. 

There's a [separate repo](https://github.com/ducksauz/esp-matter-dev)
for the build container config, and you're welcome to build it yourself
if you like, but you can also just grab the built container from dockerhub.

```bash
docker pull ducksauz/esp-matter-dev:latest
```

We'll run the build containers with `$PWD` mounted into the
container as `/workspaces`. This gives us a shared path accessible by
both the container and host OS.

```bash
docker run -it --mount type=bind,source="$(pwd)",target=/workspaces \
    ducksauz/esp-matter-dev:latest
```

## Basic build methodology

Now you're working within a shell inside the container. All the required 
SDKs (ESP IDF, Matter, Thread, and all their dependencies) are installed 
in the container and paths are set for you to just get to work. Let's build
the hello_world example to make sure that basic tooling is working properly.
`cd examples/hello_world`

Configure for target board
`idf.py set-target esp32c6`

Check out the menu config
* lots of options to explore
* defaults will probably be fine
`idf.py menuconfig`

build all
`idf.py all`

You'll get an esptool command line to flash, which you need to do from the localhost, not the container.
`#TODO insert example esptool cli and explain path mess`



