FROM docker.n8n.io/n8nio/n8n:latest

USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg python3-pip ca-certificates curl && \
    pip3 install --no-cache-dir yt-dlp && \
    rm -rf /var/lib/apt/lists/*

USER node
