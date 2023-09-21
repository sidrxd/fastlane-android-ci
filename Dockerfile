# Use the Ubuntu 20.04 base image
FROM ubuntu:20.04

# Maintainer information
MAINTAINER Siddharth Shakya <sid7830@gmail.com>

# Environment variables
ENV VERSION_TOOLS "8512546"
ENV ANDROID_SDK_ROOT "/sdk"
ENV ANDROID_HOME "${ANDROID_SDK_ROOT}"
ENV PATH "$PATH:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools"
ENV DEBIAN_FRONTEND noninteractive
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
# Update packages and install dependencies
RUN apt-get -qq update \
 && apt-get install -qqy --no-install-recommends \
      bzip2 \
      curl \
      git-core \
      html2text \
      openjdk-17-jdk \
      libc6-i386 \
      lib32stdc++6 \
      lib32gcc1 \
      lib32ncurses6 \
      lib32z1 \
      unzip \
      locales \
      ruby2.7 \
      ruby2.7-dev \
      build-essential \
      wget \
      gnupg2 \
      apt-transport-https \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Generate locale
RUN locale-gen en_US.UTF-8

# Configure Java certificates
RUN rm -f /etc/ssl/certs/java/cacerts; \
    /var/lib/dpkg/info/ca-certificates-java.postinst configure

# Install Android SDK Command-line Tools
RUN curl -s https://dl.google.com/android/repository/commandlinetools-linux-${VERSION_TOOLS}_latest.zip > /cmdline-tools.zip \
 && mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
 && unzip /cmdline-tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools \
 && mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
 && rm -v /cmdline-tools.zip

# Create licenses directory and accept licenses
RUN mkdir -p $ANDROID_SDK_ROOT/licenses/ \
 && echo "8933bad161af4178b1185d1a37fbf41ea5269c55\nd56f5187479451eabf01fb78af6dfcb131a6481e\n24333f8a63b6825ea9c5514f83c2829b004d1fee" > $ANDROID_SDK_ROOT/licenses/android-sdk-license \
 && echo "84831b9409646a918e30573bab4c9c91346d8abd\n504667f4c0de7af1a06de9f4b1727b84351f2910" > $ANDROID_SDK_ROOT/licenses/android-sdk-preview-license \
 && yes | sdkmanager --licenses >/dev/null

# Create .android directory
RUN mkdir -p /root/.android \
 && touch /root/.android/repositories.cfg \
 && sdkmanager --update

# Install Ruby bundler and Fastlane
RUN gem install bundler \
 && gem install fastlane

FROM jenkins/jenkins:latest

# Switch to root user for administrative tasks
USER root

# Install additional packages and dependencies
RUN apt-get update && apt-get install -y \
    gnupg2 \
    apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

# Switch back to the Jenkins user
USER jenkins

# Set the working directory or any other custom configurations if needed
# WORKDIR /path/to/your/app

# You can add more instructions below as needed
