#*******************************************************************************
#    (c) 2019 Zondax GmbH
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
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get -y install build-essential ccache golang-go git wget sudo udev zip \
    curl cmake software-properties-common afl++ apt-utils coreutils

# Install Python
RUN apt-get update && apt-get -y install python3 python3-pip python-is-python3

# udev rules
ADD 20-hw1.rules /etc/udev/rules.d/20-hw1.rules

RUN dpkg --add-architecture i386
RUN apt-get update && \
    apt-get -y install libudev-dev libusb-1.0-0-dev && \
    apt-get -y install libc6:i386 libncurses5:i386 libstdc++6:i386 libc6-dev-i386 -y > /dev/null && \
    apt-get -y install binutils-arm-none-eabi

# Install Python dependencies
RUN pip3 install -U setuptools ledgerblue pillow conan

# ARM compilers
ADD install_compiler.sh /tmp/install_compiler.sh
RUN echo "5811228bf42074da1574d530059b55a4fe2a8730762ce14252113a500259647d  /tmp/install_compiler.sh" | sha256sum --check 
RUN /tmp/install_compiler.sh

# Create zondax user
ARG ZONDAX_USERID
RUN adduser --disabled-password --gecos "" -u $ZONDAX_USERID zondax
RUN echo "zondax ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
WORKDIR /home/zondax

####################################
####################################
USER zondax

# Install ghr
RUN go get -u -v github.com/tcnksm/ghr

# Install Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
RUN . /home/zondax/.cargo/env && rustup target add thumbv6m-none-eabi

# Install rust 1.43 (required by zcash app)
RUN . /home/zondax/.cargo/env && rustup toolchain install 1.43.0
RUN . /home/zondax/.cargo/env && rustup target add thumbv6m-none-eabi --toolchain 1.43.0
RUN . /home/zondax/.cargo/env && rustup default 1.43.0

# Install rust 1.47 (required by zcash app)
RUN . /home/zondax/.cargo/env && rustup toolchain install 1.47.0
RUN . /home/zondax/.cargo/env && rustup target add thumbv6m-none-eabi --toolchain 1.47.0
RUN . /home/zondax/.cargo/env && rustup default 1.47.0

# ENV
RUN mkdir -p /home/zondax/.ccache
RUN echo "cache_dir = /project/.ccache" > /home/zondax/.ccache/ccache.conf

ADD entrypoint.sh /home/zondax/entrypoint.sh

# START SCRIPT
ENTRYPOINT ["/home/zondax/entrypoint.sh"]
