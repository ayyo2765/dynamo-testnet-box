# testnet-box docker image

FROM ubuntu:bionic

# install dependencies - do not set as ENV 
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive TZ=America/New_York \
	apt-get install --yes vim less net-tools make wget libevent-dev software-properties-common && \
	add-apt-repository -y ppa:bitcoin/bitcoin && \
	apt-get install --yes libdb4.8-dev libdb4.8++-dev


# # # install libboost and dependencies
# RUN wget "http://archive.ubuntu.com/ubuntu/pool/main/b/boost1.58/libboost1.58-dev_1.58.0+dfsg-5ubuntu3.1_amd64.deb" && \
# 	dpkg --force-depends -i libboost1.58-dev_1.58.0+dfsg-5ubuntu3.1_amd64.deb && \
# 	rm "libboost1.58-dev_1.58.0+dfsg-5ubuntu3.1_amd64.deb"

# create a non-root user
RUN adduser --disabled-login --gecos "" tester

# run following commands from user's home directory
WORKDIR /home/tester

ENV CORE_URL "https://github.com/foxdproject/foxdcoin/releases/download/v1.1.0/foxdcoin-v1.1.0.0-b394e97.tar.gz"

# download and install binaries
RUN mkdir tmp && \
	cd tmp && \
	wget "${CORE_URL}" && \
	tar xzf "$(basename ${CORE_URL})" && \
	cd "$(basename -s .tar.gz ${CORE_URL})/bin" && \
	install --mode 755 --target-directory /usr/local/bin *

# clean up
RUN rm -r tmp

# copy the testnet-box files into the image
ADD . /home/tester/testnet-box

# make tester user own the testnet-box
RUN chown -R tester:tester /home/tester/testnet-box

# color PS1
RUN mv /home/tester/testnet-box/.bashrc /home/tester/ && \
	cat /home/tester/.bashrc >> /etc/bash.bashrc

# use the tester user when running the image
USER root

# run commands from inside the testnet-box directory
WORKDIR /home/tester/testnet-box

# expose two rpc ports for the nodes to allow outside container access
EXPOSE 19001 19011
CMD ["/bin/bash"]
