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
FROM ubuntu:18.04

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && \
    apt-get -y install \
    \
    android-tools-adb \ 
    android-tools-fastboot \ 
    autoconf \ 
    automake \ 
    bc \ 
    bison \ 
    bsdmainutils \ 
    build-essential \
    ccache \ 
    chrpath \ 
    coreutils \ 
    corkscrew \ 
    cpio \ 
    cscope \ 
    curl \ 
    cvs \ 
    desktop-file-utils \ 
    device-tree-compiler \ 
    diffstat \ 
    docbook \ 
    docbook-utils \ 
    dos2unix \ 
    expect \ 
    flex \ 
    ftp-upload \ 
    g++ \ 
    gawk \ 
    gcc \ 
    gcc-multilib \ 
    gdisk \ 
    git \
    git-core \ 
    help2man \ 
    iasl \ 
    iputils-ping \ 
    lib32ncurses5 \ 
    libarchive-zip-perl \ 
    libattr1-dev \ 
    libc6 \ 
    libcap-dev \ 
    libfdt-dev \ 
    libftdi-dev \ 
    libglib2.0-dev \ 
    libgmp3-dev \ 
    libhidapi-dev \ 
    libncurses5-dev \ 
    libncursesw5-dev \ 
    libpixman-1-dev \ 
    libsdl1.2-dev \ 
    libssl-dev \ 
    libstdc++6 \ 
    libtool \ 
    libxml2-utils \ 
    libz1 \ 
    linux-headers-generic \ 
    locales \ 
    lrzsz \ 
    make \ 
    mercurial \ 
    mtools \ 
    nano \
    ncurses-dev \ 
    netcat \ 
    python-crypto \ 
    python-dev \
    python-pip \
    python-pycryptopp \ 
    python-pyelftools \ 
    python-pysqlite2 \ 
    python-serial \ 
    python-wand \ 
    python3 \ 
    python3-crypto \ 
    python3-dev \ 
    python3-pip \
    python3-pyelftools \ 
    python3-serial \ 
    repo \ 
    rsync \
    sed \ 
    subversion \ 
    sudo \ 
    texi2html \ 
    texinfo \ 
    tmux \ 
    u-boot-tools \ 
    unzip \ 
    uuid-dev \ 
    vim \ 
    wget \
    xdg-utils \ 
    xmlto \ 
    xterm \ 
    xz-utils \ 
    zlib1g-dev \ 
    zsh

# Fix locale issues
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

# Fetch latest repo tool
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo \
        && chmod a+x /usr/bin/repo

# Change default shell
RUN chsh -s $(which zsh)

# Create zondax user
RUN adduser --disabled-password --gecos "" -u 1000 --shell /usr/bin/zsh zondax
RUN echo "zondax ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

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

# Install Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
RUN echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> $HOME/.zshrc
RUN echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> $HOME/.bashrc
RUN $HOME/.cargo/bin/rustup target add armv7-unknown-linux-gnueabihf
RUN $HOME/.cargo/bin/rustup target add aarch64-unknown-linux-gnu
RUN $HOME/.cargo/bin/rustup target add aarch64-unknown-linux-musl

USER root
