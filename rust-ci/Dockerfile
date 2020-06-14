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
FROM circleci/rust:latest

RUN cargo install sccache
ENV RUSTC_WRAPPER sccache
ENV SCCACHE_CACHE_SIZE 1G

RUN rustup component add clippy
RUN cargo install cargo-audit
RUN cargo install cargo-tree
RUN cargo install cargo-license
RUN cargo install cargo-outdated
RUN cargo install cargo-watch https
RUN cargo install wasm-pack

ENV DEBIAN_FRONTEND noninteractive

# Install latest node
RUN sudo curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

RUN sudo apt-get update && \
    sudo apt-get install -y nodejs curl yarn apt-utils

RUN sudo yarn global add n
RUN sudo n latest -q
