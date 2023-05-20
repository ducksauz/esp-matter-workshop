# Workshop Examples

All this example code is coming right from the various SDK codebases,
either `esp-matter`, `connectedhomeip`, or `openthread`. They're 
copied into this workshop repo for convenience.

TODO: Ensure I've got all the proper licenses included each example file.


## hello_world

This is from the ESP-IDF SDK. This is just to make sure that you can
build and flash code onto the devices.

<details>
<summary>click to expand</summary>

```bash
cd /workspaces/examples/hello_world
```

Configure for the target board. We've got support for all the various esp32
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

When you're done poking around the menuconfig, quit without saving and run 
the build.

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

### Flashing the dev board

Connect one of your dev boards to your laptop via the USB-C to UART port,
which is the port in the bottom right of the diagram below. With the component
side up and the USB-C ports pointing down, it is the port on the left.

![Annotated diagram of ESP32-C6 board](specs/esp32-c6-devkitc-1-v1-annotated-photo.png)

The device port should be something like the following depending on your OS:

* Linux: `/dev/tty-usbserialXXXX`
* macOS: `/dev/tty.usbserial-NNN`
* Windows: `COM5` (need a windows person in the workshop to help here)

Now we need to go back to a shell in your host OS to flash the dev board,

```bash
cd path/to/esp-matter-workshop
cd examples/hello_world
```

At the end of the build output above, you got a very long `esptool.py` command line.
You'll call esptool however you installed it in your host OS (whether it is a standalone
executable or a python script) and then copy everything after the port parameter. I've
added lines for readability below, but you can just copy/pasta everything from `-b` onward.

```bash
esptool --port /dev/tty.usbserial-220 \
    -b 460800 --before default_reset --after hard_reset \
    --chip esp32c6  write_flash --flash_mode dio --flash_size 2MB \
    --flash_freq 80m \ 
    0x0 build/bootloader/bootloader.bin \
    0x8000 build/partition_table/partition-table.bin \
    0x10000 build/hello_world.bin
```

### Check out that hello_world

Once you've flashed the board, connect to the same serial port with
terminal emulator. On Linux and macOS, screen is cheap and dirty. You
want to sub in whatever your serial port was from above.

Serial settings: 115200,8,N,1. No flow control.

```bash
screen /dev/tty.usbserial-220 115200

Restarting in 4 seconds...
Restarting in 3 seconds...
Restarting in 2 seconds...
Restarting in 1 seconds...
Restarting in 0 seconds...
Restarting now.
ESP-ROM:esp32c6-20220919
Build:Sep 19 2022
rst:0xc (SW_CPU),boot:0xc (SPI_FAST_FLASH_BOOT)
Saved PC:0x4001975a
SPIWP:0xee
mode:DIO, clock div:2
load:0x4086c410,len:0xd5c
load:0x4086e610,len:0x2b20
load:0x40875720,len:0x17d4
entry 0x4086c410
I (26) boot: ESP-IDF 420ebd2 2nd stage bootloader
I (27) boot: compile time May 19 2023 19:45:21
I (28) boot: chip revision: v0.0
I (30) boot.esp32c6: SPI Speed      : 40MHz
I (35) boot.esp32c6: SPI Mode       : DIO
I (39) boot.esp32c6: SPI Flash Size : 2MB
I (44) boot: Enabling RNG early entropy source...
W (49) bootloader_random: bootloader_random_enable() has not been implemented yet
I (58) boot: Partition Table:
I (61) boot: ## Label            Usage          Type ST Offset   Length
I (68) boot:  0 nvs              WiFi data        01 02 00009000 00006000
I (76) boot:  1 phy_init         RF data          01 01 0000f000 00001000
I (83) boot:  2 factory          factory app      00 00 00010000 00100000
I (91) boot: End of partition table
I (95) esp_image: segment 0: paddr=00010020 vaddr=42010020 size=07340h ( 29504) map
I (115) esp_image: segment 1: paddr=00017368 vaddr=40800000 size=00cb0h (  3248) load
I (118) esp_image: segment 2: paddr=00018020 vaddr=42000020 size=0d068h ( 53352) map
I (142) esp_image: segment 3: paddr=00025090 vaddr=40800cb0 size=083ech ( 33772) load
I (159) esp_image: segment 4: paddr=0002d484 vaddr=408090a0 size=01054h (  4180) load
I (166) boot: Loaded app from partition at offset 0x10000
I (167) boot: Disabling RNG early entropy source...
W (168) bootloader_random: bootloader_random_enable() has not been implemented yet
I (187) cpu_start: Unicore app
I (188) cpu_start: Pro cpu up.
W (198) clk: esp_perip_clk_init() has not been implemented yet
I (204) cpu_start: Pro cpu start user code
I (204) cpu_start: cpu freq: 160000000 Hz
I (205) cpu_start: Application information:
I (207) cpu_start: Project name:     hello_world
I (213) cpu_start: App version:      f383536
I (218) cpu_start: Compile time:     May 19 2023 19:44:31
I (224) cpu_start: ELF file SHA256:  7cd2dd783ea9cec9...
I (230) cpu_start: ESP-IDF:          420ebd2
I (235) cpu_start: Min chip rev:     v0.0
I (239) cpu_start: Max chip rev:     v0.99
I (244) cpu_start: Chip rev:         v0.0
I (249) heap_init: Initializing. RAM available for dynamic allocation:
I (256) heap_init: At 4080AF90 len 00071680 (453 KiB): D/IRAM
I (262) heap_init: At 4087C610 len 00002F54 (11 KiB): STACK/DIRAM
I (269) heap_init: At 50000010 len 00003FF0 (15 KiB): RTCRAM
I (276) spi_flash: detected chip: generic
I (280) spi_flash: flash io: dio
W (284) spi_flash: Detected size(8192k) larger than the size in the binary image header(2048k). Using the size in the binary image .
I (297) sleep: Configure to isolate all GPIO pins in sleep state
I (304) sleep: Enable automatic switching of GPIO sleep configuration
I (311) coexist: coex firmware version: ebddf30
I (316) coexist: coexist rom version 5b8dcfa
I (322) app_start: Starting scheduler on CPU0
I (326) main_task: Started on CPU0
I (326) main_task: Calling app_main()
Hello world!
This is esp32c6 chip with 1 CPU core(s), WiFi/BLE, 802.15.4 (Zigbee/Thread), silicon revision v0.0, 2MB external flash
Minimum free heap size: 474624 bytes
```

</details>



## light

This implements a color temperature light (no RGB). It comes from the 
esp-matter SDK examples directory. When you connect to it on the serial
console, it's default output does not include pairingcodes or QR code URL.

<details>
<summary>click to expand</summary>

* build it

```bash
# in the build container
cd /workspaces/examples/light
idf.py set-target esp32c6
idf.py menuconfig
idf.py build
```

<details>
<summary>build output</summary>

```bash
[1144/1145] Generating binary image from built executableesptool.py v4.5.1
Creating esp32c6 image...
Merged 2 ELF sections
Successfully created esp32c6 image.
Generated /workspaces/examples/light/build/light.bin
[1145/1145] cd /workspaces/examples/light/build/esp-idf/esptool_...e/partition-table.bin /workspaces/examples/light/build/light.binlight.bin binary size 0x16e990 bytes. Smallest app partition is 0x1c0000 bytes. 0x51670 bytes (18%) free.

Project build complete. To flash, run this command:
/opt/esp/tools/python_env/idf5.1_py3.9_env/bin/python ../../../opt/esp/idf/components/esptool_py/esptool/esptool.py -p (PORT) -b 460800 --before default_reset --after hard_reset --chip esp32c6  write_flash --flash_mode dio --flash_size 4MB --flash_freq 40m 0x0 build/bootloader/bootloader.bin 0xc000 build/partition_table/partition-table.bin 0x20000 build/light.bin
or run 'idf.py -p (PORT) flash'
```

Build should take around 15m. (Took 13m on my 6 year old quad core i7 imac under docker)
</details>

* flash it

```bash
esptool.py -p (PORT) -b 460800 --before default_reset --after hard_reset --chip esp32c6  write_flash --flash_mode dio --flash_size 4MB --flash_freq 40m 0x0 build/bootloader/bootloader.bin 0xc000 build/partition_table/partition-table.bin 0x20000 build/light.bin
```

* connect to serial console
* check out pairing code

```bash 
> matter help

  esp             Usage: matter esp <sub_command>
  base64          Base64 encode / decode utilities
  exit            Exit the shell application
  help            List out all top level commands
  version         Output the software version
  ble             BLE transport commands
  wifi            Usage: wifi <subcommand>
  config          Manage device configuration. Usage to dump value: config [param_name] and to set some values (discriminator): con.
  device          Device management commands
  onboardingcodes Dump device onboarding codes. Usage: onboardingcodes none|softap|ble|onnetwork [qrcode|qrcodeurl|manualpairingcode]
  dns             Dns client commands
  ota             OTA commands
Done
> matter onboardingcodes ble manualpairingcode

```

* ask your neighbors what pairing code they got
* See how many of you can pair with someone else's device

</details>


## factory partition

So, as you can see, that was a default built into the code and used mostly
for CI testing. As we saw in the security overview, each device needs a
unique attestation cert, pairing code, and QR code for the packaging.

The Manufacturing Tool does the work of creating the nvs partition that
contains the key, cert, and SPAKE2 secret. It also generates the QR code
with the SPAKE2 secret for pairing.

<details>
<summary>click to expand</summary>

We're going to work through some of the instructions in 
[Manufacturing Tool Docs](https://github.com/espressif/esp-matter/blob/273efe2/tools/mfg_tool/README.md).

First, we need to pull up `idf.py menuconfig` and reconfigure the app to use
credentials from the nvs partitions we're also about to create. Read over
the intro and then jump to the [Configure Your App](https://github.com/espressif/esp-matter/blob/273efe2/tools/mfg_tool/README.md#configure-your-app) section. Follow the insructions there
to set the Commissioning, Attestation, and Manufacturing options. Save and quit
when you're done to save changes to `sdkconfig`

You'll need to rebuild the application partition, so probably best
to kick of an `idf.py build` in this container and we'll go run another
instance of the container to mess around with the Manufacturing Tool.

```bash
# Let's start another build container on your host os
cd path/to/esp-matter-workshop
docker run -it --mount type=bind,source="$(pwd)",target=/workspaces \
    ducksauz/esp-matter-dev:latest /bin/bash
```

Check out the help for `mfg_tool.py`. I've truncated the help output. 
There are a lot of interesting options there to play with.


```bash
# In the new container
# Add the tool to the path because I missed it.
PATH=/opt/esp/esp-matter/tools/mfg_tool:${PATH}

# Check out 
# mfg_tool.py -h
usage: mfg_tool.py [-h] [-n COUNT] [-s SIZE] [-e] [--passcode PASSCODE] [--discriminator DISCRIMINATOR] [-cf {0,1,2}]
                   [-dm {0,1,2}] [-cn CN_PREFIX] [-lt LIFETIME] [-vf VALID_FROM] [-c CERT] [-k KEY] [-cd CERT_DCLRN]
                   [--dac-cert DAC_CERT] [--dac-key DAC_KEY] [--paa | --pai] [-v VENDOR_ID] [--vendor-name VENDOR_NAME]
                   [-p PRODUCT_ID] [--product-name PRODUCT_NAME] [--hw-ver HW_VER] [--hw-ver-str HW_VER_STR] [--mfg-date MFG_DATE]
                   [--serial-num SERIAL_NUM] [--enable-rotating-device-id] [--rd-id-uid RD_ID_UID]
                   [--calendar-types CALENDAR_TYPES [CALENDAR_TYPES ...]] [--locales LOCALES [LOCALES ...]]
                   [--fixed-labels FIXED_LABELS [FIXED_LABELS ...]] [--product-label PRODUCT_LABEL] [--product-url PRODUCT_URL]
                   [--csv CSV] [--mcsv MCSV]

```

First, we'll just make a single partition.

```bash
CRED_PATH=/opt/esp/esp-matter/connectedhomeip/connectedhomeip/credentials
$ mfg_tool.py -cn "My Awesome Bulb" -v 0xFFF2 -p 0x8001 --pai \
    -k ${CRED_PATH}/test/attestation/Chip-Test-PAI-FFF2-8001-Key.pem \
    -c ${CRED_PATH}/test/attestation/Chip-Test-PAI-FFF2-8001-Cert.pem \
   -cd ${CRED_PATH}/test/certification-declaration/Chip-Test-CD-FFF2-8001.der
```

Take a look at the certs and keys that will end up in the factory partition.
Note: `$SOME_UID` will be a randomly generated UID 

```bash
$ ls -l out/fff2_8001/$SOME_UID/internal/
total 28
-rw-r--r-- 1 root root  497 May 20 03:34 DAC_cert.der
-rw-r--r-- 1 root root  729 May 20 03:34 DAC_cert.pem
-rw-r--r-- 1 root root  227 May 20 03:34 DAC_key.pem
-rw-r--r-- 1 root root   32 May 20 03:34 DAC_private_key.bin
-rw-r--r-- 1 root root   65 May 20 03:34 DAC_public_key.bin
-rw-r--r-- 1 root root  449 May 20 03:34 PAI_cert.der
-rw-r--r-- 1 root root 1059 May 20 03:34 partition.csv
```

* Take a look at the certs with `openssl x509`
* Check out the `partition.csv` file for what's happening there. How do you think these options map to the command line options?




</details>


## light again, but built for factory partition

Now, we should have what we need to all get unique device discriminators
and pairing codes. Some quick reflashing and we can try it out.

<details>
<summary>click to expand</summary>

### Erase the device

Especially when you're changing device credentials, it's a good idea to
just wipe flash before you reprogram so you don't end up with spurious
behavior due to old data.

```bash
# On the host machine
$ esptool.py -p /dev/tty.usbserial-10 erase_flash
esptool.py v4.5.1
Serial port /dev/tty.usbserial-10
Connecting....
Detecting chip type... ESP32-C6
Chip is ESP32-C6 (revision v0.0)
Features: WiFi 6, BT 5, IEEE802.15.4
Crystal is 40MHz
MAC: 60:55:f9:f6:fd:0c
Uploading stub...
Running stub...
Stub running...
Erasing flash (this may take a while)...
Chip erase completed successfully in 2.2s
Hard resetting via RTS pin...
```

### Flash the application

```bash
esptool.py -p (PORT) -b 460800 --before default_reset --after hard_reset --chip esp32c6  write_flash --flash_mode dio --flash_size 4MB --flash_freq 40m 0x0 build/bootloader/bootloader.bin 0xc000 build/partition_table/partition-table.bin 0x20000 build/light.bin
```

### Flash the factory partition

```bash
esptool.py -p /dev/tty.usbserial-10 write_flash \
    0x10000 out/fff2_8001/$SOME_UID/$SOME_UID-partition.bin
```

This is as good a time as any to talk about the flash partition table.
We get this output early in the build process.

```log
[3/1145] Generating ../../partition_table/partition-table.binPartition table binary generated. Contents:
*******************************************************************************
# ESP-IDF Partition Table
# Name, Type, SubType, Offset, Size, Flags
esp_secure_cert,63,6,0xd000,8K,encrypted
nvs,data,nvs,0x10000,24K,
nvs_keys,data,nvs_keys,0x16000,4K,encrypted
phy_init,data,phy,0x17000,4K,
ota_0,app,ota_0,0x20000,1792K,
ota_1,app,ota_1,0x1e0000,1792K,
ot_storage,data,fat,0x3a0000,24K,
*******************************************************************************
```

It's computed from the partition csv template file configured in `sdkconfig`.
We're using partitions_thread.csv because that's the default for the esp32c6
and esp32h2 devices.

```bash
$ cat partitions_thread.csv
# Name,   Type, SubType, Offset,  Size, Flags
# Note: Firmware partition offset needs to be 64K aligned, initial 36K (9 sectors) are reserved for bootloader and partition table
esp_secure_cert,  0x3F, ,0xd000,     0x2000, encrypted
nvs,       data, nvs,     0x10000,   0x6000,
nvs_keys, data, nvs_keys, ,          0x1000, encrypted
phy_init,  data, phy,     ,          0x1000,
ota_0,    app, ota_0,     ,          0x1C0000,
ota_1,    app, ota_1,     ,          0x1C0000,
# For Wi-Fi device, this partition can be deleted.
ot_storage,data, fat,     ,          0x6000,
```

`esp_secure_cert` and `nvs_keys` are related to firmware and config
security. `nvs` is the partition that will hold the device attestation
certs and key. `phy_init` holds radio calibration data and mac address
info (I think). `ota_0` and `ota_1` are two slots to hold the application
image, allowing the device to safely do OTA updates without bricking itself.
Lastly, `ot_storage` is for (Open)Thread device credential storage for to
access the Thread network to which it is joined.

The bootloader and partition table are in flash starting at 0x0000 and 0xc000,
respectively. These are both configurable in `sdkconfig`

```text
CONFIG_BOOTLOADER_OFFSET_IN_FLASH=0x0
CONFIG_PARTITION_TABLE_OFFSET=0xC000
```

You should be able to just pull up the QR code for the partition you flashed.
Open `out/fff2_8001/$SOME_UID/$SOME_UID-qrcode.png` and scan it with your
smart home app, which should probably be Home.app (iOS) or Google Home App 
(Android).

</details>


## OpenThread CLI

Now, we're going take some time and play around with the Thread side of things.

To save you the trouble of building it, I've got pre-built images to load the
OpenThread CLI. We're going to get our hand dirty and configure an IOT device
like it's a Cisco router. Obviously, this gets handled automagically when you
use the QR codes and a commissioning application, but it's always good to know
how this stuff works under the hood.

This exercise is based on the [ot_cli](https://github.com/espressif/esp-idf/tree/56123c52aa/examples/openthread/ot_cli) example in the `esp-idf` repo.

<details>
<summary>click to expand</summary>

### Flash the `ot-cli` image

```bash
# On your host machine
cd path/to/esp-matter-workshop
cd examples/ot-cli

esptool.py -p ${PORT} -b 460800 --before default_reset --after hard_reset \
  --chip esp32c6  write_flash --flash_mode dio --flash_size 8MB \
  --flash_freq 80m \
  0x0 build/bootloader/bootloader.bin \
  0x8000 build/partition_table/partition-table.bin \
  0x10000 build/esp_ot_cli.bin
```

### Check out some of the ot-cli commands

```log
> discover
>

| Network Name     | Extended PAN     | PAN  | MAC Address      | Ch | dBm | LQI |
+------------------+------------------+------+------------------+----+-----+-----+
| NEST-PAN-BCC2    | abcd7676acbd7676 | bcc2 | 021a2b3c32323232 | 13 | -74 |  30 |
| OpenThreadDemo   | 1111111122222222 | 1234 | ceb04c89f89bafa9 | 15 | -75 |  25 |
| MyHome123456788  | efda4321efda4321 | 54ea | 021a2b3cdfdfdf55 | 24 | -101 |   0 |
| MyHome123456788  | efda4321efda4321 | 54ea | 021a2b3c8a8a3a44 | 25 | -67 |  66 |

> counters
> 

```


### Join the workshop Thread network

Connect via serial console to the ESP32. You'll need to adjust your serial
settings to perform local echo, as the ot-cli doesn't echo what you type.
Annoying, but easily remedied. Depending on what tool you're using to make
the serial connection, you might want/need to save the local echo as a
different profile, quit, and reconnect with that profile. I had to do this
with `minicom`

We're going to join all the modules to an OTBR up here. I used the same
command on the OTBR to dump the active dataset as is in the 

```bash
john@touchpi:~/thread-sandbox/ot-br-posix/build/otbr/tools $ sudo ot-ctl dataset active -x
0e080000000000010000000300000f35060004001fffe0020811111111222222220708fd0907de4e41c5f0051000112233445566778899aabbccddeeff030e4f70656e54687265616444656d6f010212340410445f2b5ca6f2a93a55ce570a70efeecb0c0402a0f7f8
```

From our serial terminal sessions, we're going apply that to `ot-cli` running on both
your esp32c6 modules.

```bash
> factoryreset
# the device will reboot

> dataset set active 0e080000000000010000000300000f35060004001fffe0020811111111222222220708fd0907de4e41c5f0051000112233445566778899aabbccddeeff030e4f70656e54687265616444656d6f010212340410445f2b5ca6f2a93a55ce570a70efeecb0c0402a0f7f8
> ifconfig up
Done
> thread start
Done

# After some seconds

> state
router  # child is also a valid state
Done

```

</details>


## any other example app

TODO: It's late. I'll do this live tomorrow.

<details>
<summary>click to expand</summary>

</details>


[def]: https://github.com/espressif/esp-idf/tree/56123c52aa/examples/openthread/ot_cli