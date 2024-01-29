FROM ghcr.io/linuxserver/baseimage-kasmvnc:alpine318

RUN apk add --no-cache firefox && echo "firefox" > /defaults/autostart

# RUN apt-get update; \
    # apt-get install -y x11vnc xvfb python3 python3-pip; \
    # apt-get -y clean;
# RUN mkdir ~/.vnc

COPY . /app
WORKDIR /app

# RUN pip install playwright && playwright install

EXPOSE 3000 3001 9080
