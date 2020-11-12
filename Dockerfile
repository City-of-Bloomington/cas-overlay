FROM ubuntu:latest AS overlay
ARG VERSION

RUN apt-get update && apt-get install -y gradle

WORKDIR /srv
RUN mkdir -p cas-overlay
COPY ./src cas-overlay/src/
COPY ./gradle/ cas-overlay/gradle/
COPY ./gradlew ./settings.gradle ./build.gradle ./gradle.properties cas-overlay/

RUN mkdir -p cas-overlay/.gradle \
    && echo "org.gradle.daemon=false" >> cas-overlay/.gradle/gradle.properties \
    && echo "org.gradle.configureondemand=true" >> cas-overlay/.gradle/gradle.properties \
    && cd /srv/cas-overlay \
    && chmod 750 ./gradlew \
    && ./gradlew --version;

RUN cd /srv/cas-overlay \
    && ./gradlew clean build --parallel --no-daemon;

FROM ubuntu:latest AS cas
RUN apt-get update && apt-get install -y default-jre-headless

LABEL "Organization"="City of Bloomington"
LABEL "Description"="City of Bloomington CAS"

RUN cd / \
    && mkdir -p /etc/cas/config \
    && mkdir -p /etc/cas/services \
    && mkdir -p /etc/cas/saml \
    && mkdir -p /srv/sites/cas;

COPY --from=overlay /srv/cas-overlay/build/libs/cas.war /srv/sites/cas/
# We're building an image for Kubernetes, so don't store any config locally
#COPY etc/cas/ /etc/cas/
#COPY etc/cas/config/log4j2.xml /etc/cas/config/log4j2.xml
#COPY etc/cas/services/ /etc/cas/services/
#COPY etc/cas/saml/ /etc/cas/saml/

#EXPOSE 8080 8443

ENV PATH $PATH:$JAVA_HOME/bin:.

WORKDIR /srv/sites/cas
ENTRYPOINT ["java", "-server", "-noverify", "-Xmx2048M", "-jar", "cas.war"]
