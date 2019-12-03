FROM alpine:3.7

# Some ENV variables
ENV MM_VERSION=5.6.2

# Install some needed packages
RUN apk add --no-cache \
    ca-certificates \
    curl \
    jq \
    libc6-compat \
    libffi-dev \
    linux-headers \
    mailcap \
    netcat-openbsd \
    xmlsec-dev \
    && rm -rf /tmp/*

# Get Mattermost
RUN mkdir -p /mattermost/data /mattermost/plugins /mattermost/client/plugins \
    && curl https://releases.mattermost.com/$MM_VERSION/mattermost-team-$MM_VERSION-linux-amd64.tar.gz | tar -xvz \
    && cp /mattermost/config/config.json /config.json.save \
    && rm -rf /mattermost/config/config.json

# Configure entrypoint
ENTRYPOINT ["mattermost"]
WORKDIR /mattermost

# Expose port 8065 of the container
EXPOSE 8065
