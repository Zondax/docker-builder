#*******************************************************************************
#    (c) 2020 Zondax GmbH
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

# Install Python
RUN apt-get update && apt-get -y install python3 python3-pip
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN pip3 install -U setuptools ledgerblue pillow

# Speculos dependencies
RUN apt-get update && apt-get -y install qemu-user-static python3-pyqt5 python3-construct \
                                 python3-mnemonic python3-pyelftools gcc-arm-linux-gnueabihf \
                                 libc6-dev-armhf-cross gdb-multiarch libvncserver-dev \
                                 mesa-utils and libgl1-mesa-glx

# Create zondax user
RUN adduser --disabled-password --gecos "" -u 1000 zondax
RUN echo "zondax ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
WORKDIR /home/zondax

####################################
####################################
USER zondax

# Speculos - use patched fork
RUN git clone -b master https://github.com/LedgerHQ/speculos.git
RUN cd /home/zondax/speculos && git checkout 677586b1c3caa00df61b63c0b718b2fbf5245eda
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
