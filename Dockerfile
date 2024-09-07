FROM debian:latest AS builder

ARG PB_VERSION=0.22.20

RUN apt-get update && apt-get install -y --no-install-recommends \
    unzip \
    ca-certificates \
    openssh-client && \
    rm -rf /var/lib/apt/lists/*

ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip

RUN unzip /tmp/pb.zip -d /pb/

FROM gcr.io/distroless/static

COPY --from=builder /pb /pb

COPY --from=builder /etc/ssl/certs /etc/ssl/certs

EXPOSE 8080

CMD ["/pb/pocketbase", "serve", "--http=0.0.0.0:8080"]
