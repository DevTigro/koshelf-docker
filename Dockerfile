FROM debian:12-slim AS downloader

RUN apt-get update && apt-get install -y \
    curl \
    file \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

ARG KOSHELF_VERSION=v0.1.0
ARG TARGETARCH

RUN echo "Building for architecture: ${TARGETARCH}" && \
    case ${TARGETARCH} in \
    "amd64") ARCH="x86_64" ;; \
    "arm64") ARCH="aarch64" ;; \
    *) echo "Unsupported architecture: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    echo "Downloading for: ${ARCH}" && \
    curl -L "https://github.com/paviro/KoShelf/releases/download/${KOSHELF_VERSION}/koshelf-${ARCH}-unknown-linux-musl" \
    -o /tmp/koshelf && \
    chmod +x /tmp/koshelf && \
    file /tmp/koshelf

FROM gcr.io/distroless/static-debian12

COPY --from=downloader --chown=65532:65532 /tmp/koshelf /koshelf

USER 65532

ENTRYPOINT ["/koshelf", "--books-path", "/books", "--statistics-db", "/settings/statistics.sqlite3", "--port", "3000"]