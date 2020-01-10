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
# Based on https://www.yoctoproject.org/docs/2.0/yocto-project-qs/yocto-project-qs.html
FROM ubuntu:18.04

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" \
    apt-get -y install android-tools-adb android-tools-fastboot autoconf \
        automake bc bison build-essential ccache cscope curl device-tree-compiler \
        expect flex ftp-upload gdisk iasl libattr1-dev libc6 libcap-dev \
        libfdt-dev libftdi-dev libglib2.0-dev libhidapi-dev libncurses5-dev \
        libpixman-1-dev libssl-dev libstdc++6 libtool libz1 make \
        mtools netcat python-crypto python3-crypto python-pyelftools \
        python3-pyelftools python-serial python3-serial rsync unzip uuid-dev \
        xdg-utils xterm xz-utils zlib1g-dev

RUN apt-get update && \
    apt-get -y install repo ccache sudo build-essential libgmp3-dev python3-dev python-dev \
    python3-pip python-pip wget cpio

RUN pip3 install pycryptodomex
RUN pip install pycryptodomex

####################################
####################################
# Create test user
RUN adduser --disabled-password --gecos "" -u 1000 test
RUN echo "test ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
WORKDIR /home/test
USER test
ADD entrypoint.sh /home/test/entrypoint.sh

####################################
####################################

ENV TARGET default
RUN mkdir -p tztest
RUN cd tztest && \
    repo init -u https://github.com/OP-TEE/manifest.git -m ${TARGET}.xml && \
    repo sync -j4 --no-clone-bundle

RUN cd tztest/build && make -j `nproc` toolchains
RUN cd tztest/build && make -j `nproc`

ADD install.sh /home/test/install.sh
RUN /home/test/install.sh

# START SCRIPT
ENTRYPOINT ["/home/test/entrypoint.sh"]
