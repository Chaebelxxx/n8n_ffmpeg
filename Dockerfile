# Stage 1: a regular Alpine image (has apk) just to download ffmpeg
FROM alpine:3.20 AS ffmpeg-downloader
RUN apk add --no-cache curl xz
RUN curl -L https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz -o /tmp/ffmpeg.tar.xz \
    && mkdir /tmp/ffmpeg \
    && tar -xf /tmp/ffmpeg.tar.xz -C /tmp/ffmpeg --strip-components=1

# Stage 2: your actual n8n image
FROM n8nio/n8n:latest
USER root
COPY --from=ffmpeg-downloader /tmp/ffmpeg/ffmpeg /usr/local/bin/ffmpeg
COPY --from=ffmpeg-downloader /tmp/ffmpeg/ffprobe /usr/local/bin/ffprobe
RUN chmod +x /usr/local/bin/ffmpeg /usr/local/bin/ffprobe
USER node
