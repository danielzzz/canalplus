canalplus
=========

*** this project is no longer maintained ***

in an era where online tv did not existed very much yet, I created this projet to capture my tv signal and stream it online, so I could watch any channel on my mobile.

it featured:
* data capture
* adruino ir dongle to switch channels (sic!)
* vlc transcoding and streaming to mobile

vlc capture and streaming scripts, arduino+node app for remote control, mobile compatible

I use it to stream canal plus around the house vía wifi, and to watch and control it using my android phone.


This is a set of scripts and code I use for streaming and controlling canal plus channels around my house. It's a simple hack, I combined my other projects and it may contain some redundant, residual code. Use it at your own risk.

You need:
- a canal plus decoder (obviously)
- a capture card (I use a conceptronic usb dongle - 1b80:e34e)
- arduino + an IR diode for reverse eng remote control
- vlc >= 2.0
- node

I have ubuntu on my machine.

I) Streaming

a) Capture card setup.

My card is a cheap conceptronic dongle, which identifies itself with lsusb as 1b80:e34e Afatech

It's been a bit tricky to get it to work, but with:

sudo -s
modprobe em28xx


the last command was needed because for some reason the system didn't created a /dev/videoX entry by itself.


to know which audio device you should be using, execute

arecord -l

in my case the output is:

**** Lista de CAPTURE dispositivos hardware ****
tarjeta 0: Intel [HDA Intel], dispositivo 0: ALC1200 Analog [ALC1200 Analog]
  Subdispositivos: 1/1
  Subdispositivo #0: subdevice #0
tarjeta 0: Intel [HDA Intel], dispositivo 2: ALC1200 Analog [ALC1200 Analog]
  Subdispositivos: 1/1
  Subdispositivo #0: subdevice #0
tarjeta 1: CODEC [USB Audio CODEC], dispositivo 0: USB Audio [USB Audio]
  Subdispositivos: 1/1
  Subdispositivo #0: subdevice #0
tarjeta 3: Em28xxAudio [Em28xx Audio], dispositivo 0: Em28xx Audio [Empia 28xx Capture]
  Subdispositivos: 1/1
  Subdispositivo #0: subdevice #0


and we can see that the device Em28xxAudio has the number 3. which gives us hw:3,0

* It seems there is some regression bug in the driver, because the audio stopped working recently...
I workaround this connecting the audio output of the c+ decoder directly to another audio card input and using this.

Once done, you can execute the streaming/init.sh script. if everything goes ok you should be able to watch it using "cvlc mmsh://localhost:9002/tv"

II) Arduino

In order to be able to change channels over the network I scanned the original remote codes and recreated them using an IR diode and arduino. Upload the firmware from the arduino directory using the IDE and you should be good to go.

to change channes you can send the following command vía the serial port:
irsend:digit_1:[digit_2]

for example:
irsend:652 - on-off
irsend:642 - channel 1

the codes for each key go here
$jsonButtons = '[{"key":"on-off","code1":"652","code2":"2700"},{"key":"info","code1":"655","code2":"2703"},{"key":"1","code1":"641","code2":"2689"},{"key":"2","code1":"642","code2":"2690"},{"key":"3","code1":"643","code2":"2691"},{"key":"4","code1":"644","code2":"2692"},{"key":"5","code1":"645","code2":"2693"},{"key":"6","code1":"646","code2":"2694"},{"key":"7","code1":"647","code2":"2695"},{"key":"8","code1":"648","code2":"2696"},{"key":"9","code1":"649","code2":"2697"},{"key":"0","code1":"640","code2":"2688"}]';



* This is a general purpose firmware. You can also use it for analog/digital reading writting - if you need it. Look into the source for more details.


III) Proxy

It's a node application that works as a proxy between arduino and the web. It sends codes to the arduino vía a serial connection, and reads back the status. Uses Ajax for communication.

IV) Web panel

A simple, mobile-adapted, web panel for changing channels.


V) Utils

Some utils scripts.
