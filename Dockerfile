FROM mcr.microsoft.com/playwright:v1.41.0-jammy

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update; \
    apt-get install -y x11vnc xvfb python3 python3-pip; \
    apt-get -y clean;
RUN mkdir ~/.vnc

COPY . /app
WORKDIR /app

RUN pip install playwright && playwright install

EXPOSE 5900
