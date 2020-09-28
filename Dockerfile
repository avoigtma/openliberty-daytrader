FROM openliberty/open-liberty:kernel-java8-openj9-ubi

## docker build -t daytrader-sample:1.0-SNAPSHOT .

ARG VERSION=1.0
ARG REVISION=SNAPSHOT

LABEL \
  org.opencontainers.image.authors="Your Name" \
  org.opencontainers.image.vendor="IBM" \
  org.opencontainers.image.url="local" \
  org.opencontainers.image.source="https://github.com/OpenLiberty/guide-getting-started" \
  org.opencontainers.image.version="$VERSION" \
  org.opencontainers.image.revision="$REVISION" \
  vendor="Open Liberty" \
  name="system" \
  version="$VERSION-$REVISION" \
  summary="WebSphere Liberty daytrader sample application" \
  description="WebSphere Liberty daytrader sample application."

# Add my app and config
COPY --chown=1001:0  io.openliberty.sample.daytrader8.war /config/apps/
COPY --chown=1001:0  server.xml /config/

# Add interim fixes (optional)
#COPY --chown=1001:0  interim-fixes /opt/ol/fixes/

# Default setting for the verbose option
ARG VERBOSE=false

# This script will add the requested XML snippets, grow image to be fit-for-purpose and apply interim fixes
RUN configure.sh

