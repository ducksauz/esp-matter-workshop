# esp-matter-workshop
ESP Matter Workshop for BSides Seattle 2023

# Prereqs
[ ] Git
[ ] Visual Studio Code
[ ] Docker
[ ] esptool

# Check out this workshop repo
`git clone https://github.com/ducksauz/esp-matter-workshop.git`

# explain how to prime the dev container



# Basic build methodology 

configure for target board
`idf.py set-target esp32s3`

check out the menu config 
* lots of options to explore
* defaults will probably be fine
`idf.py menuconfig`

build all
`idf.py all`

You'll get an esptool command line to flash, which you need to do from the localhost, not the container.
`#TODO insert example esptool cli and explain path mess`



