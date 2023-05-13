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

```bash
cd /workspaces/examples/hello_world
```

Configure for target board. We've got support for all the various esp32 
targets in the container, but we're just working with esp32c6 today.

```bash
idf.py set-target esp32c6
```

Check out the menuconfig! I haven't had to custom compile a linux kernel
in ages, but this is just like that was the last time I did it. You shouldn't
have to change anything for the hello_world build, but you'll definitely
learn some options here. Especially with flash partitioning and component
enablement. For example, if you were building a low power Matter device 
with the esp32c6, you could make a device that just uses the BLE and Thread
support and skip building in wifi at all to save a lot of code space and power.

When you're done poking around the menuconfig, go ahead and run the build.

```bash
idf.py menuconfig
idf.py build
```


After five or so minutes and close to a thousand build commands, the build
will be done and the tail of your build output will look something like this.

```bash
-- Build files have been written to: /workspaces/examples/hello_world/build/bootloader
[103/104] Generating binary image from built executableesptool.py v4.5.1
Creating esp32c6 image...
Merged 1 ELF section
Successfully created esp32c6 image.
Generated /workspaces/examples/hello_world/build/bootloader/bootloader.bin
[104/104] cd /workspaces/examples/hello_world/build/bootloader/esp-idf/es...ader 0x0 /workspaces/examples/hello_world/build/bootloader/bootloader.binBootloader binary size 0x50b0 bytes. 0x2f50 bytes (37%) free.
[890/891] Generating binary image from built executableesptool.py v4.5.1
Creating esp32c6 image...
Merged 1 ELF section
Successfully created esp32c6 image.
Generated /workspaces/examples/hello_world/build/hello_world.bin
[891/891] cd /workspaces/examples/hello_world/build/esp-idf/esptool_py &&...artition-table.bin /workspaces/examples/hello_world/build/hello_world.binhello_world.bin binary size 0x1e500 bytes. Smallest app partition is 0x100000 bytes. 0xe1b00 bytes (88%) free.

Project build complete. To flash, run this command:
/opt/esp/tools/python_env/idf5.1_py3.9_env/bin/python ../../opt/esp/idf/components/esptool_py/esptool/esptool.py -p (PORT) -b 460800 --before default_reset --after hard_reset --chip esp32c6  write_flash --flash_mode dio --flash_size 2MB --flash_freq 80m 0x0 build/bootloader/bootloader.bin 0x8000 build/partition_table/partition-table.bin 0x10000 build/hello_world.bin
or run 'idf.py -p (PORT) flash'
root@b6f14b7080a6:/workspaces/examples/hello_world#
```

## Flashing the dev board

Connect one of your dev boards to your laptop via the USB-C to UART port.
With the component side up and the USB-C ports pointed down, it is the port
on the left.

![Annotated diagram of ESP32-C6 board](specs/esp32-c6-devkitc-1-v1-annotated-photo.png)

Now we need to go back to a shell in your host OS to flash the dev board,

```bash
cd path/to/esp-matter-workshop
cd examples/hello_world


```


You'll get an esptool command line to flash, which you need to do from the localhost, not the container.
`#TODO insert example esptool cli and explain path mess`



