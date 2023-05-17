#!/bin/bash

PORT=/dev/tty.usbserial-10

esptool.py -p ${PORT} -b 460800 --before default_reset --after hard_reset \
  --chip esp32c6  write_flash --flash_mode dio --flash_size 8MB \
  --flash_freq 80m \
  0x0 build/bootloader/bootloader.bin \
  0x8000 build/partition_table/partition-table.bin \
  0x10000 build/esp_ot_cli.bin

