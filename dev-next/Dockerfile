FROM --platform=$TARGETPLATFORM alpine AS builder

RUN set -ex \
  && apk upgrade \
  && apk add curl wget jq bash tzdata ca-certificates \
  && rm -rf /var/cache/apk/*

# 设置 sing-box 版本
SB_VERSION=$(curl -s https://api.github.com/repos/SagerNet/sing-box/releases | jq -r 'map(select(.prerelease == true) | .tag_name) | .[0]')
ENV SB_VERSION="$SB_VERSION"

# 获取当前系统和架构
ARG TARGETOS
ARG TARGETARCH

# 构建下载 URL
ENV DOWNLOAD_URL "https://github.com/jklolixxs/test/releases/download/${SB_VERSION}/sing-box-${TARGETOS}-${TARGETARCH}"

# 下载并解压 sing-box
RUN if [ "$TARGETOS" = "windows" ]; then \
      wget -O /tmp/sing-box.zip $DOWNLOAD_URL.zip \
      && unzip /tmp/sing-box.zip -d /tmp/ \
      && mv /tmp/sing-box /usr/local/bin/sing-box \
      && chmod +x /usr/local/bin/sing-box \
      && rm /tmp/sing-box.zip; \
    else \
      wget -O /tmp/sing-box.tar.gz $DOWNLOAD_URL.tar.gz \
      && tar -xzvf /tmp/sing-box.tar.gz -C /tmp/ \
      && mv /tmp/sing-box /usr/local/bin/sing-box \
      && chmod +x /usr/local/bin/sing-box \
      && rm /tmp/sing-box.tar.gz; \
    fi

FROM --platform=$TARGETPLATFORM alpine AS dist
RUN set -ex \
  && apk upgrade \
  && apk add bash tzdata ca-certificates \
  && rm -rf /var/cache/apk/*

COPY --from=builder /usr/local/bin/sing-box /usr/local/bin/sing-box
ENTRYPOINT [ "/usr/local/bin/sing-box" ]
