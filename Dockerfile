FROM debian:10-slim

ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install git

ARG RPI_FIRMWARE_GIT_BRANCH=4.19.97-v7l

RUN git clone -b "${RPI_FIRMWARE_GIT_BRANCH}" https://github.com/ARM-PIt/rpi-firmware-essentials.git /tmp/rpi-firmware-essentials && \
    git clone --depth=1 https://github.com/raspberrypi/userland /tmp/userland && \
    mkdir /opt/vc && \
    mkdir /lib/modules && \
    cp -a /tmp/rpi-firmware-essentials/hardfp/opt/* /opt/ && \
    cp -a /tmp/rpi-firmware-essentials/modules/* /lib/modules/ && \
    cp -a /tmp/userland/interface/* /usr/include/ && \
    ln -s /opt/vc/bin/vcgencmd /usr/bin/vcgencmd && \
    echo "/opt/vc/lib" > /etc/ld.so.conf.d/00-vmcs.conf && \
    ldconfig

RUN apt-get -y --purge remove git && \
    apt-get update && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/

CMD ["/bin/bash"]
