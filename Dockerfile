FROM docker.n8n.io/n8nio/n8n:latest

USER root
# 安装 curl 和 tar
RUN apk add --no-cache curl tar xz

# 下载 yt-dlp
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
    -o /usr/local/bin/yt-dlp && \
    chmod a+rx /usr/local/bin/yt-dlp

# 下载并解压静态版 FFmpeg
RUN curl -L https://github.com/BtbN/FFmpeg-Builds/releases/latest/download/ffmpeg-n6.1.1-linux64-gpl-6.1.tar.xz \
    -o /tmp/ffmpeg.tar.xz && \
    mkdir -p /opt/ffmpeg && \
    tar -xJf /tmp/ffmpeg.tar.xz -C /opt/ffmpeg --strip-components=1 && \
    ln -s /opt/ffmpeg/bin/ffmpeg /usr/local/bin/ffmpeg && \
    ln -s /opt/ffmpeg/bin/ffprobe /usr/local/bin/ffprobe && \
    rm -f /tmp/ffmpeg.tar.xz

USER node
