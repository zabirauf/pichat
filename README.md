# PiChat

A simple chat application using Phoenix framework. We can create an embedded image and run it on Raspberry Pi 2.

##Create Raspberry PI 2 image
[Nerves-Project](http://nerves-project.org) uses the Erlang/Elixir release and creates a bootable firmware image from that using [Buildroot](http://buildroot.net/).This creates a bare bone image, stripping away all the useless things for embedded system such as video, UI etc. which in turn makes it bootup pretty quickly.

Lets first pull in the docker image, run it and run few commands under it.
```bash-language
$ docker pull zabirauf/nerves-sdk-elixir-rpi2
$ docker run -i -t -v /path/to/pi_chat:/opt/pi_chat zabirauf/nerves-sdk-elixir-rpi2 /bin/bash
root@bb9f59897a2a: cd /Downloads/nerves-sdk && source ./nerves-env.sh
```

Now in your docker terminal which is still running the docker container lets create the image
```
root@bb9f59897a2a: cd /opt/pi_chat
root@bb9f59897a2a: MIX_ENV=prod make
```
This will compile the project, create an erlang release from it and then use that release to create an image. After that is done your image would be under `/path/to/pi_chat/_images`.

##Burning image on SD Card
I am using Mac so the instructions would be for Mac. If you are on Linux or Windows then you can get the instructions to burn `.img` on SD card by just searching for it.

First run `diskutil list` and see where is your SD card mounted _(in my case its /dev/disk7)_. Then run the following

**CAUTION:** Wrong disk path can cause you to loose data for that disk. Make sure you are using the right SD card path. 
```bash-language
$ sudo diskutil unmountDisk /dev/disk7
$ sudo dd bs=1m if=/path/to/pi_chat/_images/pi_chat.img of=/dev/disk7
```
This will take some time and then once its done you can eject the SD card. If this does not work then use the alternative method mentioned at [Raspberry Pi](https://www.raspberrypi.org/documentation/installation/installing-images/mac.md)

Now just insert the SD card in Raspberry Pi 2, connect the ethernet cable and power it up. Visit the IP of the Pi in your browser and you should be greeted with the Phoenix application. 
I found the IP by checking the console output from Raspberry Pi using [USB TTL Serial Cable](http://www.adafruit.com/product/954). If you don't have that then you can find the list of connected devices from your router admin portal and try visiting them.