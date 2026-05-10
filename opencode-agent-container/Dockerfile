ARG OPENCODE_VERSION=1.14.41
ARG RIPGREP_VERSION=15.1.0
ARG UBI_IMAGE=registry.access.redhat.com/ubi10/ubi-minimal:10.1
ARG GO_TOOLSET_IMAGE=registry.access.redhat.com/ubi10/go-toolset:1.25

FROM ${UBI_IMAGE} AS opencode-download
ARG OPENCODE_VERSION
ARG RIPGREP_VERSION
ARG TARGETARCH

RUN microdnf install -y \
    ca-certificates \
    curl \
    gzip \
    tar \
  && microdnf clean all \
  && rm -rf /var/cache/dnf /var/cache/yum

RUN set -eux; \
    arch="${TARGETARCH:-$(uname -m)}"; \
    case "$arch" in \
      amd64|x86_64) opencode_asset="opencode-linux-x64.tar.gz"; ripgrep_target="x86_64-unknown-linux-musl" ;; \
      arm64|aarch64) opencode_asset="opencode-linux-arm64.tar.gz"; ripgrep_target="aarch64-unknown-linux-gnu" ;; \
      *) echo "Unsupported architecture: $arch" >&2; exit 1 ;; \
    esac; \
    curl -fsSL \
      -o /tmp/opencode.tar.gz \
      "https://github.com/anomalyco/opencode/releases/download/v${OPENCODE_VERSION}/${opencode_asset}"; \
    mkdir -p /opt/opencode; \
    tar -xzf /tmp/opencode.tar.gz -C /opt/opencode; \
    chmod 0755 /opt/opencode/opencode; \
    /opt/opencode/opencode --version; \
    curl -fsSL \
      -o /tmp/ripgrep.tar.gz \
      "https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/ripgrep-${RIPGREP_VERSION}-${ripgrep_target}.tar.gz"; \
    mkdir -p /opt/ripgrep; \
    tar -xzf /tmp/ripgrep.tar.gz -C /opt/ripgrep --strip-components=1; \
    chmod 0755 /opt/ripgrep/rg; \
    /opt/ripgrep/rg --version

FROM ${GO_TOOLSET_IMAGE} AS vllm-proxy-build
ARG TARGETARCH

WORKDIR /opt/app-root/src
COPY cmd/vllm-h2-proxy/main.go ./main.go
RUN set -eux; \
    arch="${TARGETARCH:-$(uname -m)}"; \
    case "$arch" in \
      amd64|x86_64) goarch="amd64" ;; \
      arm64|aarch64) goarch="arm64" ;; \
      *) echo "Unsupported architecture: $arch" >&2; exit 1 ;; \
    esac; \
    CGO_ENABLED=0 GOOS=linux GOARCH="$goarch" go build -trimpath -ldflags="-s -w" -o /tmp/vllm-h2-proxy ./main.go

FROM ${UBI_IMAGE}

USER 0

RUN microdnf install -y \
    bash \
    ca-certificates \
    curl \
    findutils \
    git \
    gzip \
    jq \
    libstdc++ \
    openssh-clients \
    procps-ng \
    shadow-utils \
    tar \
    util-linux \
    which \
  && microdnf clean all \
  && rm -rf /var/cache/dnf /var/cache/yum \
  && groupadd --system opencode \
  && useradd --system --create-home --home-dir /home/opencode --gid opencode --shell /bin/bash opencode \
  && mkdir -p /workspace /home/opencode/.config/opencode /home/opencode/.local/share/opencode \
  && chown -R opencode:opencode /workspace /home/opencode

COPY localca.crt /etc/pki/ca-trust/source/anchors/localca.crt
RUN chmod 0644 /etc/pki/ca-trust/source/anchors/localca.crt \
  && update-ca-trust extract

COPY --from=opencode-download /opt/opencode/opencode /usr/local/bin/opencode
COPY --from=opencode-download /opt/ripgrep/rg /usr/local/bin/rg
COPY --from=vllm-proxy-build /tmp/vllm-h2-proxy /usr/local/bin/vllm-h2-proxy
COPY entrypoint.sh /usr/local/bin/opencode-entrypoint
RUN chmod 0755 /usr/local/bin/opencode-entrypoint

ENV HOME=/home/opencode \
    WORKSPACE_DIR=/workspace \
    OPENCODE_DISABLE_AUTOUPDATE=true

WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/opencode-entrypoint"]
CMD []
