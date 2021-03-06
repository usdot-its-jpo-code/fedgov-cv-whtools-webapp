FROM jetty:9.4.12-jre8-alpine

# The relative path to the shared object for the codec shared object
ARG CODEC_SO_PATH=target/libper-xer-codec.so

# Password for the certificate keystore
ENV JETTY_KEYSTORE_PASSWORD=CHANGEME

# The login url for the CAS
ENV CAS_SERVER_LOGIN_URL=https://my.cas.com/login
# The url prefix for the CAS
ENV CAS_SERVER_PREFIX_URL=https://my.cas.com/
# The url prefix for the Warehouse Tools Server
ENV WHTOOLS_SERVER_PREFIX_URL=https://my.whtools.com/

# If set to a non-empty string, the keystore will be imported into the trust
# store. This is necessary if your SSL certificates are not trusted by java
# by default, i.e. self-signed
ENV TRUST_KEYSTORE=

# Copy in war file, associated configuration xml, and codec binary
COPY whtools.xml "$JETTY_BASE/webapps/whtools.xml"
COPY ${CODEC_SO_PATH} /usr/lib/libper-xer-codec.so
COPY target/whtools.war /opt/whtools.war

RUN mkdir $JETTY_BASE/etc/

# Add in new entrypoint script
USER root
RUN mv /docker-entrypoint.sh /jetty-docker-entrypoint.sh
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh