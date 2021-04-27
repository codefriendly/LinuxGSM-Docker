#
# LinuxGSM Dockerfile
#
# https://github.com/GameServerManagers/LinuxGSM-Docker
#

FROM ubuntu:20.04

LABEL maintainer="LinuxGSM <me@danielgibbs.co.uk>"

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386 \
&& apt-get update \
&& apt -y upgrade \
&& apt-get install -y locales \
&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

## Auto accept steamcmd license
RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
 && echo steam steam/license note '' | debconf-set-selections

## Base System
RUN ACCEPT_EULA=y apt install -y \
    vim \
    apt-transport-https \
    bc \
    binutils \
    bsdmainutils \
    bzip2 \
    ca-certificates \
    curl \
    default-jre \
    expect \
    file \
    gzip \
    iproute2 \
    jq \
    libtbb2 \
    mailutils \
    netcat \
    postfix \
    python \
    telnet \
    tmux \
    unzip \
    util-linux \
    wget \
    xz-utils \
    zlib1g \
    lib32gcc1 \
    lib32stdc++6 \
    libsdl2-2.0-0:i386 \
    steamcmd \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

## user config
RUN groupadd -g 750 -o linuxgsm \
&& adduser --uid 750 --disabled-password --gecos "" --ingroup linuxgsm linuxgsm \
&& usermod -aG tty linuxgsm \
&& usermod -aG sudo linuxgsm \
&& chown -R linuxgsm:linuxgsm /home/linuxgsm/ \
&& chmod 755 /home/linuxgsm

RUN wget -O /linuxgsm.sh https://linuxgsm.sh \
&& chmod +x /linuxgsm.sh \
&& cp /linuxgsm.sh /home/linuxgsm/linuxgsm.sh \
&& chown 750:750 /home/linuxgsm/linuxgsm.sh

USER linuxgsm
WORKDIR /home/linuxgsm

VOLUME [ "/home/linuxgsm" ]

# need use xterm for LinuxGSM
ENV TERM=xterm

## Docker Details
ENV PATH=$PATH:/home/linuxgsm

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["bash","/entrypoint.sh" ]
