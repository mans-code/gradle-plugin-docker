# this a mulit satage docker build
# stage 1 compil java code and, create a configered liberty server
FROM adoptopenjdk/openjdk15:jdk-15.0.2_7-alpine as builder

#---stage 1 preparation: installing gradle
ENV GRADLE_VERSION 6.8.3

RUN apk -U add --no-cache curl; \
    curl https://downloads.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip > gradle.zip; \
    unzip gradle.zip; \
    rm gradle.zip; \
    apk del curl; \
    apk update && apk add --no-cache libstdc++ && rm -rf /var/cache/apk/*

ENV PATH=${PATH}:/gradle-${GRADLE_VERSION}/bin

#-----stage 1 creating a configered liberty server
WORKDIR /app

COPY build.gradle .
COPY settings.gradle .

RUN gradle libertyCreate

#-----stage 1 compil code and generate
COPY src src

RUN gradle compilJava
RUN gradle  war

# --------------  stage 2 ------------
## stage 2 uses files generted by stages 1 to deploy liberty server
#
#FROM openliberty/open-liberty:21.0.0.3-full-java15-openj9-ubi
#
##-----stage 2 Add config to liberty
#COPY --chown=1001:0 --from=builder /app/build/wlp/usr/servers/defaultServer/server.xml /config/
#COPY --chown=1001:0  --from=builder /app/build/wlp/usr/servers/defaultServer/configDropins/overrides/liberty-plugin-variable-config.xml /config/configDropins/overrides/
#
##-----stage 2 Add war to liberty
#COPY --chown=1001:0 --from=builder /app/build/libs/BasicV3.war /config/apps/
#
##-----stage 2 run :)
#RUN configure.sh

