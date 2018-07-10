FROM websphere-liberty:microProfile
MAINTAINER IBM Java engineering at IBM Cloud
COPY /target/liberty/wlp/usr/servers/defaultServer /config/
#COPY /target/liberty/wlp/usr/shared/resources /config/resources/
#COPY /src/main/liberty/config/jvmbx.options /config/jvm.options
# Install required features if not present, install APM Data Collector

## Copy in portfolio prereqs:

## These two lines could be merged, might not be much gain.
COPY /lib/db2jcc4.jar,/lib/wmq.jmsra.rar /config/


RUN installUtility install --acceptLicense defaultServer
# Upgrade to production license if URL to JAR provided
ARG LICENSE_JAR_URL
RUN \ 
  if [ $LICENSE_JAR_URL ]; then \
    wget $LICENSE_JAR_URL -O /tmp/license.jar \
    && java -jar /tmp/license.jar -acceptLicense /opt/ibm \
    && rm /tmp/license.jar; \
  fi
