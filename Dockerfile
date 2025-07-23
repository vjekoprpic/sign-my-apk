FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG APKTOOL_VERSION=2.9.3
ARG BUILD_TOOLS_VERSION=35.0.0

# 1) Base deps
RUN apt-get update && apt-get install -y \
    openjdk-17-jre-headless wget unzip zipalign \
    && rm -rf /var/lib/apt/lists/*

# 2) apktool
RUN wget -qO /usr/local/bin/apktool.jar https://github.com/iBotPeaches/Apktool/releases/download/v${APKTOOL_VERSION}/apktool_${APKTOOL_VERSION}.jar \
 && echo '#!/bin/sh\nexec java -jar /usr/local/bin/apktool.jar "$@"' > /usr/local/bin/apktool \
 && chmod +x /usr/local/bin/apktool

# 3) Android build-tools (for apksigner if not provided by apt)
ENV ANDROID_HOME=/opt/android-sdk \
    PATH=/opt/android-sdk/build-tools/${BUILD_TOOLS_VERSION}:$PATH
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools \
 && wget -qO /tmp/cmdtools.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip \
 && unzip -q /tmp/cmdtools.zip -d ${ANDROID_HOME}/cmdline-tools \
 && mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
 && rm /tmp/cmdtools.zip \
 && yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --licenses >/dev/null \
 && ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager "build-tools;${BUILD_TOOLS_VERSION}" >/dev/null

# 4) Add build script
WORKDIR /work
COPY build.sh /usr/local/bin/build.sh
RUN chmod +x /usr/local/bin/build.sh

# Default command (override if you want)
CMD ["/usr/local/bin/build.sh"]

