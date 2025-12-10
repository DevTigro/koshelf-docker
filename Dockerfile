FROM debian:12-slim AS downloader

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    file \
    jq \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

ARG KOSHELF_VERSION=latest
ARG TARGETARCH

RUN if [ "$KOSHELF_VERSION" = "latest" ]; then \
        echo "Fetching latest KoShelf version..." && \
        KOSHELF_VERSION=$(curl -s https://api.github.com/repos/paviro/KoShelf/releases/latest | jq -r .tag_name) && \
        echo "Latest version: $KOSHELF_VERSION"; \
    fi && \
    echo "$KOSHELF_VERSION" > /tmp/version.txt

RUN KOSHELF_VERSION=$(cat /tmp/version.txt) && \
    echo "Building for architecture: ${TARGETARCH}" && \
    case ${TARGETARCH} in \
        amd64) ARCH="x86_64" ;; \
        arm64) ARCH="aarch64" ;; \
        *) echo "Unsupported architecture: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    URL="https://github.com/paviro/KoShelf/releases/download/${KOSHELF_VERSION}/linux-musl-${ARCH}.zip" && \
    echo "Downloading from: ${URL}" && \
    curl -fSL "${URL}" -o koshelf.zip && \
    unzip koshelf.zip && \
    chmod +x koshelf && \
    echo "Downloaded binary info:" && \
    file koshelf && \
    ls -lh koshelf

RUN ./koshelf --github || echo "Binary check completed"

FROM alpine:3.22

COPY --from=downloader /tmp/version.txt /version.txt
COPY --from=downloader /tmp/koshelf /koshelf
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

RUN adduser -D -u 65532 koshelf && \
    chown koshelf:koshelf /koshelf

ENV KOSHELF_BOOKS_PATH="/books"
ENV KOSHELF_STATISTICS_DB="/settings/statistics.sqlite3"
ENV KOSHELF_PORT="3000"
ENV KOSHELF_OUTPUT=""
ENV KOSHELF_WATCH="false"
ENV KOSHELF_TITLE=""
ENV KOSHELF_INCLUDE_UNREAD="false"
ENV KOSHELF_HEATMAP_SCALE_MAX=""
ENV KOSHELF_TIMEZONE=""
ENV KOSHELF_DAY_START_TIME=""
ENV KOSHELF_MIN_PAGES_PER_DAY=""
ENV KOSHELF_MIN_TIME_PER_DAY=""
ENV KOSHELF_DOCSETTINGS_PATH=""
ENV KOSHELF_HASHDOCSETTINGS_PATH=""

USER 65532

LABEL org.opencontainers.image.title="KoShelf"
LABEL org.opencontainers.image.description="Self-hosted ebook library with KOReader integration"
LABEL org.opencontainers.image.source="https://github.com/paviro/KoShelf"

ENTRYPOINT ["/entrypoint.sh"]
