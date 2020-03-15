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
FROM zondax/builder-base

RUN pip3 install pycryptodomex
RUN pip install pycryptodomex

USER zondax
WORKDIR /home/zondax

ENV TARGET qemu_v8
ENV OPTEE_URL https://github.com/OP-TEE/manifest.git
ENV NO_AT_BRIDGE 1

# Build OPTEE & QEMU
RUN mkdir -p optee
RUN cd optee && \
    repo init --depth=1 --no-clone-bundle -u ${OPTEE_URL} -m ${TARGET}.xml && \
    repo sync -c -j$(nproc --all) --fetch-submodules --current-branch --no-clone-bundle
RUN cd optee/build && make -j `nproc` toolchains
RUN cd optee/build && make -j `nproc` QEMU_VIRTFS_ENABLE=y QEMU_USERNET_ENABLE=y

RUN sudo apt-get update && sudo apt-get -y install \
    dbus-x11 \ 
    dconf-editor \
    gnome-terminal \
    libcanberra-gtk-module \
    libcanberra-gtk3-module  \ 
    net-tools \
    x11-apps \
    lbzip2

####################################

ENV QEMU_V8=1

ADD entrypoint.sh /home/zondax/entrypoint.sh
ENTRYPOINT ["/home/zondax/entrypoint.sh"]
