#*******************************************************************************
#    (c) 2019 ZondaX GmbH
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
    apt-get -y install build-essential git sudo wget cmake libssl-dev libgmp-dev autoconf libtool
    
RUN adduser --disabled-password --gecos "" -u 1000 test
RUN echo "test ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
WORKDIR /home/test

# Python
RUN apt-get update && apt-get -y install python-pip
RUN pip install -U setuptools conan
