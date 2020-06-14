#*******************************************************************************
#    (c) 2020 ZondaX GmbH
# 
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
# 
#       http://www.apache.org/licenses/LICENSE-2.0
# 
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#*******************************************************************************
#Download base ubuntu image
FROM ubuntu:18.04
RUN apt-get update && \
    apt-get -y install build-essential git wget sudo udev zip \
                       curl cmake software-properties-common

RUN dpkg --add-architecture i386
RUN apt-get update && \
    apt-get -y install libudev-dev libusb-1.0-0-dev 
    # apt-get -y install libc6:i386 libncurses5:i386 libstdc++6:i386 libc6-dev-i386 -y > /dev/null && \
    # apt-get -y install binutils-arm-none-eabi


# Install Python
RUN apt-get update && apt-get -y install python3 python3-pip
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN pip3 install -U setuptools ledgerblue pillow

# Speculos dependencies
RUN apt-get update && apt-get -y install qemu-user-static python3-pyqt5 python3-construct \
                                 python3-mnemonic python3-pyelftools gcc-arm-linux-gnueabihf \
                                 libc6-dev-armhf-cross gdb-multiarch libvncserver-dev

# Create zondax user
RUN adduser --disabled-password --gecos "" -u 1000 zondax
RUN echo "zondax ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
WORKDIR /home/zondax


####################################
####################################
USER zondax

# Speculos - use patched fork
RUN git clone https://github.com/ZondaX/speculos.git
RUN mkdir -p /home/zondax/speculos/build
RUN cd /home/zondax/speculos && cmake -Bbuild -H. -DWITH_VNC=1
RUN make -C /home/zondax/speculos/build/

# Patch proxy to connect to all interfaces
RUN sed -i "s/HOST = '127.0.0.1'/HOST = '0.0.0.0'/g" speculos/tools/ledger-live-http-proxy.py

# Open TCP ports
# gdb
EXPOSE 1234/tcp
EXPOSE 1234/udp
# device keyboard
EXPOSE 1235/tcp
EXPOSE 1235/udp
# APDU RAW
EXPOSE 9999/tcp
EXPOSE 9999/udp
# HTTP APDU PROXY
EXPOSE 9998/tcp
EXPOSE 9998/udp
# RFB
EXPOSE 8001/tcp
EXPOSE 8001/udp

# ENV
ADD entrypoint.sh /home/zondax/entrypoint.sh

RUN pip3 install -U jsonschema

# START SCRIPT
ENTRYPOINT ["/home/zondax/entrypoint.sh"]