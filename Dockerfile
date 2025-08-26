# Stage 1: Build Gitea from local source
FROM golang:1.24-bookworm AS build

# Install build dependencies
RUN apt-get update && apt-get install -y \
    git make gcc g++ xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Copy pre-downloaded Node.js tarball (download manually once on host)
# Download from: https://nodejs.org/dist/v20.17.0/node-v20.17.0-linux-x64.tar.xz
COPY node-v20.17.0-linux-x64.tar.xz /tmp/node.tar.xz

# Extract Node.js into /usr/local
RUN tar -xJf /tmp/node.tar.xz -C /usr/local --strip-components=1 \
    && rm /tmp/node.tar.xz \
    && node -v && npm -v

# Set workdir for source
WORKDIR /src

# Copy local Gitea source
COPY gitea/ ./

# Build backend + frontend assets
RUN TAGS="bindata sqlite sqlite_unlock_notify" make build


# Stage 2: Minimal runtime image
FROM debian:bookworm-slim AS runtime

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    git openssh-client sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# Create user and directories
RUN groupadd -r gitea && useradd -r -g gitea gitea \
    && mkdir -p /data /config /app/gitea \
    && chown -R gitea:gitea /data /config /app

WORKDIR /app/gitea

# Copy built binary from builder stage
COPY --from=build /src/gitea /app/gitea/gitea

EXPOSE 3000 22

USER gitea
CMD ["/app/gitea/gitea", "web"]
