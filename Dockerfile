FROM mcr.microsoft.com/playwright:v1.41.1-jammy

RUN apt update && apt install -y python3 python3-pip

COPY . /app
WORKDIR /app

RUN pip3 install playwright && playwright install

