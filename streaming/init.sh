#!/bin/bash
#python -m SimpleHTTPServer 8086

# --- optimal -------------------

# activate the card
# modprobe em28xx card=9
# echo 1b80 e34e > /sys/bus/usb/drivers/em28xx/new_id
# arecord -l

# make sure you configured input devices according to your system's settings

echo "starting canal+ streaming"
cvlc v4l2:///dev/video1 :v4l2-width=488 :v4l2-height=422 :v4l2-standard= :input-slave=alsa://hw:1,0 :live-caching=1000 -I dummy --extraintf http --http-host=0.0.0.0 --http-port 9002   -f --sout="#transcode{vcodec=mp4v, vb=600,vfilter=croppadd{croptop=46,cropbottom=70}, fps=15,scale=1,ab=64,acodec=mp3,channels=1,samplerate=48000,audio-sync}:gather:std{mux=asfh,access=mmsh,dst=0.0.0.0:9002/tv,name='DanTV'}" --sout-keep

# -----------------------------------------------------

# alternative configurations and tests

#remove old fragments
rm -rf *.ts
rm -rf *.m3u8

# canal+
#vlc v4l2:///dev/video1 :v4l2-standard= :input-slave=alsa://hw:3,0 :live-caching=300 -I dummy -vv -f --extraintf http --http-host 192.168.1.128 --http-port 8082 --mms-caching 0 --sout='#transcode{width=320,height=240,fps=25,vcodec=h264,vb=256,venc=x264{aud,profile=baseline,level=30,keyint=15,min-keyint=15,ref=1},acodec=mp3,ab=96,audio-sync}:std{access=livehttp{seglen=5,delsegs=true,numsegs=5,index=/home/daniel/projekty/_moje/video/livehttp/mystream.m3u8,index-url=http://192.168.1.128/mystream-########.ts},mux=ts{use-key-frames},dst=/home/daniel/projekty/_moje/video/livehttp/mystream-########.ts}'

# tv
#cvlc playlist.m3u -I dummy -vv -f --extraintf http --http-host 0.0.0.0 --http-port 9002 --sout='#transcode{width=320,height=240,fps=25,vcodec=h264,vb=256,venc=x264{aud,profile=baseline,level=30,keyint=15,min-keyint=15,ref=1},acodec=mp3,ab=96,audio-sync}:std{access=livehttp{seglen=5,delsegs=true,numsegs=5,index=/home/daniel/projekty/_moje/video/livehttp/mystream.m3u8,index-url=http://danielzelisko.dyndns.org/mystream-########.ts},mux=ts{use-key-frames},dst=/home/daniel/projekty/_moje/video/livehttp/mystream-########.ts}'


# playlist
#vlc playlist.m3u -I dummy -vv -f --extraintf http --http-host 0.0.0.0 --http-port 8082 --mms-caching 0 --sout='#transcode{width=320,height=240,fps=25,vcodec=h264,vb=256,venc=x264{aud,profile=baseline,level=30,keyint=15,min-keyint=15,ref=1},acodec=mp3,ab=96,audio-sync}:std{access=livehttp{seglen=5,delsegs=true,numsegs=5,index=/home/daniel/projekty/_moje/video/livehttp/mystream.m3u8,index-url=http://192.168.1.128/mystream-########.ts},mux=ts{use-key-frames},dst=/home/daniel/projekty/_moje/video/livehttp/mystream-########.ts}'

# web stream
#:sout=#transcode{vcodec=WMV2,vb=400,fps=15,width=256,height=192,deinterlace,acodec=wma2,ab=64,channels=2,samplerate=44100}:duplicate{dst=std{access=http,mux=asf,dst=/},dst=display}
#:std{access=http{mime=video/x-flv},mux=ffmpeg{mux=flv},dst=0.0.0.0:8087/tv.flv}


#std{{mux=asfh,access=mmsh,dst=:9000}"
# dziala ale nie przez siec
#vlc channels.conf -I dummy -v -f --sout="#transcode{width=320,height=240,fps=25,vcodec=h264,threads=4,vb=256,venc=x264{aud,profile=veryfast,level=30,keyint=15,min-keyint=15,ref=1},acodec=mp3,ab=96,audio-sync,samplerate=48000}:rtp{dst=0.0.0.0,port=9000,proto=udp,mux=ts{use-key-frames},ttl=12}}"

# dziala u seby dla tv
#cvlc channels.conf -I dummy --extraintf http --http-host 0.0.0.0 --http-port 9002 -v -f --sout="#transcode{vcodec=WMV2,vb=512,scale=0.5,acodec=mp3,ab=64,channels=1}:gather:std{mux=asfh,access=mmsh,dst=0.0.0.0:9002/tv}" --sout-keep --no-sout-rtp-sap --no-sout-standard-sap




#cvlc v4l2:///dev/video1 :v4l2-standard= :input-slave=alsa://hw:2,0 :live-caching=1000 -I dummy --extraintf http --http-host=0.0.0.0 --http-port 9002   -f --sout="#transcode{vcodec=mp4v, vb=600,vfilter=croppadd{croptop=46,cropbottom=70}, fps=15,scale=0.6,ab=64,acodec=mp3,channels=1,samplerate=48000,audio-sync}:duplicate{dst='gather:std{mux=asfh,access=mmsh,dst=0.0.0.0:9002/tv,name=DanTV}',dst='transcode{vcodec=mjpg,fps=1}:standard{access=http{mime=multipart/x-mixed-replace;boundary=--7b3cc56e5f51db803f790dad720ed50a},mux=mpjpeg,dst=:9003/koko.mjpeg}'}" --sout-keep



#transcode{vcodec=MJPG,vb=2000,scale=1}:duplicate{dst=std{access=http,mux=mpjpeg,dst=192.168.1.178:8080/stream.mpjpg}}


#vlc test.avi  -L -I dummy --extraintf http --http-host 0.0.0.0 --http-port 9002 -v -f --sout="#transcode{vcodec=mp4v, vb=600,vfilter=croppadd{croptop=46,cropbottom=70}, fps=15,scale=1,ab=64,acodec=mp3,channels=1,samplerate=48000,audio-sync}:gather:std{mux=asfh,access=mmsh,dst=0.0.0.0:9002/tv,name='TranscodedStream'}" --sout-keep

#vlc mmsh://danielzelisko.dyndns.org:9002/tv
#echo "starting dvb"
#cvlc channels.conf -I dummy --extraintf http --http-host 0.0.0.0 --http-port 9002  -f --sout="#transcode{vcodec=mp4v, vb=600,fps=15,scale=0.6,ab=64,acodec=mp3,channels=1,samplerate=48000,audio-sync}:gather:std{mux=asfh,access=mmsh,dst=0.0.0.0:9002/tv}" --sout-keep --no-sout-rtp-sap --no-sout-standard-sap

#vlc v4l2:///dev/video1 :v4l2-standard= :input-slave=alsa://hw:2,0 :live-caching=1000 --extraintf http --http-host 0.0.0.0 --http-port 8082 --sout-mux-caching=1000 -I dummy -vv -f --sout="#transcode{width=352,height=288,fps=15,vcodec=h264,vb=256,venc=x264{aud,profile=baseline,level=30,keyint=15,min-keyint=15,ref=1,subq=4,bframes=2,b_pyramid,weight_b},acodec=mp3,ab=96,audio-sync}:gather:std{mux=asfh,access=mmsh,dst=:9000}" --sout-keep --no-sout-rtp-sap --no-sout-standard-sap

#vlc playlist.m3u -I dummy -vv -f --extraintf http --http-host 0.0.0.0 --http-port 8082 --mms-caching 0 --sout="#transcode{vcodec=h264,threads=2,idrint=2,vb=200,fps=15,width=256,height=192,ab=32,acodec=mp3,samplerate=44100,venc=x264{profile=veryfast,preset=fast,tune=grain,keyint=60}}:rtp{sdp=rtsp://:5544/}"
