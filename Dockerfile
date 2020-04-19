FROM debian:10-slim

ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get clean && \
    apt-get update && \
    apt-get full-upgrade -y && \
    apt-get install -y git

RUN git clone --depth 1 https://github.com/raspberrypi/firmware.git /tmp/firmware && \
    mkdir /opt/vc && \
    cp -a /tmp/firmware/hardfp/opt/vc/lib /opt/vc/ && \
    cp -a /tmp/firmware/hardfp/opt/vc/include /opt/vc/ && \
    rm -rf /tmp/firmware && \
    ln -s /opt/vc/bin/vcgencmd /usr/bin/vcgencmd && \
    echo "/opt/vc/lib" > /etc/ld.so.conf.d/00-vmcs.conf

RUN apt-get -y --purge remove git && \
    apt-get update && \
    apt-get -y autoremove && \
    ldconfig

CMD ["/bin/bash"]
