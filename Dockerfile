# 第1阶段：使用 Alpine 下载 yt‑dlp 和 FFmpeg 静态版
FROM alpine:3.18 AS downloader

# 安装 curl、tar 和 xz 用于下载及解压缩
RUN apk add --no-cache curl tar xz

# 下载最新的 yt‑dlp 单文件版本并赋予执行权限
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
    -o /usr/local/bin/yt-dlp && \
    chmod a+rx /usr/local/bin/yt-dlp

# 下载并解压 FFmpeg 静态版（AMD64 平台）
# 官方 FAQ 建议先下载压缩包，再用 tar 解压即可使用:contentReference[oaicite:1]{index=1}。
RUN curl -L https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz \
    -o /tmp/ffmpeg.tar.xz && \
    mkdir -p /opt/ffmpeg && \
    tar -xJf /tmp/ffmpeg.tar.xz -C /opt/ffmpeg --strip-components=1

# 第2阶段：基于官方 n8n 镜像
FROM docker.n8n.io/n8nio/n8n:latest
USER root

# 安装 python3 （如果镜像基于 Alpine）
RUN apk add --no-cache python3

# 复制 yt‑dlp 和 FFmpeg 到最终镜像
COPY --from=downloader /usr/local/bin/yt-dlp /usr/local/bin/yt-dlp
COPY --from=downloader /opt/ffmpeg /opt/ffmpeg

# 将 ffmpeg 和 ffprobe 链接到 /usr/local/bin 以便全局调用
RUN ln -s /opt/ffmpeg/ffmpeg /usr/local/bin/ffmpeg && \
    ln -s /opt/ffmpeg/ffprobe /usr/local/bin/ffprobe

# 由于 n8n 运行在 Zeabur 容器中，它无法直接访问您本地的文件，需要您将 cookie 文件放进容器。随代码一起复制：在项目根目录创建 cookies 文件夹，将 youtube_cookies.txt 放入其中，然后修改 Dockerfile
COPY cookies/www.youtube.com_cookies.txt /home/node/www.youtube.com_cookies.txt


USER node
