FROM openliberty/open-liberty:full-java11-openj9-ubi
###FROM openliberty/open-liberty:kernel-slim-java8-openj9-ubi ## slim does not work; missing modules which would need to be added
#FROM openliberty/open-liberty:kernel-java8-openj9-ubi ## this is a deprecated image as of v20.xxx

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
COPY --chown=1001:0  postgres-jdbc/*.jar /opt/ol/wlp/lib/
COPY --chown=1001:0  server.xml /config/
COPY --chown=1001:0  jvm.options /config/

# Add interim fixes (optional)
#COPY --chown=1001:0  interim-fixes /opt/ol/fixes/

# Default setting for the verbose option
ARG VERBOSE=true

# enable Transport Security in Liberty by adding the transportSecurity-1.0 feature (includes support for SSL)
ARG SSL=true

# This script will add the requested XML snippets, grow image to be fit-for-purpose and apply interim fixes
RUN configure.sh

