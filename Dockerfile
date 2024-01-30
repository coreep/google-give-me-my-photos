FROM overclockedllama/docker-chromium

# RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories \
    # && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    # && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    # && echo "http://dl-cdn.alpinelinux.org/alpine/v3.12/main" >> /etc/apk/repositories \
    # && apk upgrade -U -a \
    # && apk add --no-cache \
    # libstdc++ \
    # chromium \
    # harfbuzz \
    # nss \
    # freetype \
    # ttf-freefont \
    # font-noto-emoji \
    # wqy-zenhei \
    # python3 \
    # py3-pip \
    # tini
RUN apk add python3 py3-pip

ENV CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/ \
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1

COPY . /app
WORKDIR /app

# RUN pip3 install playwright && playwright install

# RUN echo "cd /app && python3 login.py" > /startapp.sh
# RUN echo -en "#!/usr/bin/with-contenv sh\nset -e\nset -u\n/usr/bin/chromium-browser" > /startapp.sh

# CMD '/usr/bin/chromium-browser --no-sandbox'
