FROM --platform=$BUILDPLATFORM golang:alpine AS builder
WORKDIR /go/src/github.com/reF1nd/sing-box
ARG TARGETOS TARGETARCH BRANCH
ENV CGO_ENABLED=0
ENV GOOS=$TARGETOS

RUN set -ex \
  && apk add git build-base git \
  && git clone -b dev-routestrategy --single-branch https://github.com/reF1nd/sing-box /go/src/github.com/reF1nd/sing-box \
  && go build -v -trimpath -tags \
     "with_quic,with_grpc,with_dhcp,with_wireguard,with_ech,with_utls,with_reality_server,with_acme,with_clash_api,with_v2ray_api,with_gvisor,with_sideload,with_clash_dashboard,with_randomaddr,with_jstest,with_script" \
    -o /go/bin/sing-box \
    ./cmd/sing-box

FROM --platform=$TARGETPLATFORM alpine AS dist
RUN set -ex \
  && apk upgrade \
  && apk add bash tzdata ca-certificates \
  && rm -rf /var/cache/apk/*

COPY --from=builder /go/bin/sing-box /usr/local/bin/sing-box
ENTRYPOINT [ "/usr/local/bin/sing-box" ]
