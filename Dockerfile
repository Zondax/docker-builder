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
    apt-get -y install repo ccache sudo locales build-essential libgmp3-dev python3-dev python-dev \
    python3-pip python-pip wget cpio gdisk tmux zsh vim nano

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
RUN chsh -s $(which zsh)

# Fetch latest repo tool
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo \
        && chmod a+x /usr/bin/repo

RUN pip3 install pycryptodomex
RUN pip install pycryptodomex

####################################
####################################
# Create zondax user
RUN adduser --disabled-password --gecos "" -u 1000 --shell /usr/bin/zsh zondax
RUN echo "zondax ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
WORKDIR /home/zondax
USER zondax
RUN git config --global user.email "info@zondax.ch"
RUN git config --global user.name "zondax"
RUN git config --global color.ui true

ENV ZSH_THEME agnoster
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" ""  --unattended
RUN cd $HOME; \
    git clone https://github.com/gpakosz/.tmux.git; \
    ln -s -f .tmux/.tmux.conf ; \
    cp .tmux/.tmux.conf.local .

####################################
####################################

ENV TARGET default
RUN mkdir -p optee
RUN cd optee && \
    repo init --depth=1 -u https://github.com/OP-TEE/manifest.git -m ${TARGET}.xml && \
    repo sync -c -j$(nproc --all)

RUN cd optee/build && make -j `nproc` toolchains
RUN cd optee/build && make -j `nproc`

RUN sudo apt-get update && \
    sudo apt-get -y install net-tools x11-apps dbus-x11 gnome-terminal libcanberra-gtk-module libcanberra-gtk3-module dconf-editor

ENV NO_AT_BRIDGE 1
#RUN curl https://sh.rustup.rs -sSf | bash -s -- -y


####################################
####################################
ADD entrypoint.sh /home/zondax/entrypoint.sh
ENTRYPOINT ["/home/zondax/entrypoint.sh"]
