FROM ubuntu:latest AS overlay

RUN apt-get update && apt-get install -y gradle

WORKDIR /srv/sites/cas
COPY ./src /srv/sites/cas/src/
COPY ./gradle /srv/sites/cas/gradle/
COPY ./gradlew /srv/sites/cas/gradlew/
COPY ./gradlew ./settings.gradle ./build.gradle ./gradle.properties /srv/sites/cas/

RUN mkdir -p ~/.gradle \
    && echo "org.gradle.daemon=false" >> ~/.gradle/gradle.properties \
    && echo "org.gradle.configureondemand=true" >> ~/.gradle/gradle.properties \
    && cd /srv/sites/cas \
    && chmod 750 ./gradlew \
    && ./gradlew --version;

RUN cd /srv/sites/cas \
    && ./gradlew clean build --info --parallel;


FROM ubuntu:latest AS cas
RUN apt-get update && apt-get install -y default-jre-headless

LABEL "Organization"="Apereo"
LABEL "Description"="Apereo CAS"

RUN cd / \
    && mkdir -p /etc/cas/config \
    && mkdir -p /etc/cas/services \
    && mkdir -p /etc/cas/saml \
    && mkdir -p /srv/sites/cas;

# We're building an image for Kubernetes, so don't store any config locally
#COPY etc/cas/ /etc/cas/
#COPY etc/cas/config/log4j2.xml /etc/cas/config/log4j2.xml
#COPY etc/cas/services/ /etc/cas/services/
#COPY etc/cas/saml/ /etc/cas/saml/

COPY --from=overlay /srv/sites/cas/build/libs/cas.war /srv/sites/cas/

#EXPOSE 8080 8443

ENV PATH $PATH:$JAVA_HOME/bin:.

WORKDIR /srv/sites/cas
ENTRYPOINT ["java", "-server", "-noverify", "-Xmx2048M", "-jar", "cas.war"]
