FROM alpine:3.14 as base

RUN apk add --no-cache jq curl

SHELL ["/bin/ash", "-o", "pipefail", "-c"]
RUN curl -s https://api.github.com/repos/tcnksm/ghr/releases/tags/v0.15.0 | \
    jq -r '.assets[] | select(.browser_download_url | contains("linux_amd64"))  | .browser_download_url' | \
    xargs curl -o ghr.tgz -sSL && \
    mkdir -p ghr && \
    tar xzf ghr.tgz && \
    mv ghr_v*_linux_amd64/ghr /usr/local/bin
RUN curl -sL https://github.com/moul/retry/releases/download/v0.5.0/retry_Linux_x86_64 -o /usr/local/bin/retry && \
    chmod +x /usr/local/bin/retry

RUN ls -la
RUN ls ghr_v*_linux_amd64
RUN ls /usr/local/bin

RUN /usr/local/bin/retry
RUN /usr/local/bin/ghr

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
