FROM overclockedllama/docker-chromium

RUN apk add python3 py3-pip --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community

COPY . /app
WORKDIR /app

RUN pip3 install playwright && playwright install

RUN echo "cd /app && python3 login.py" > /startapp.sh
