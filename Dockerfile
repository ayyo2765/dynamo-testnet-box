# testnet-box docker image

FROM ubuntu:bionic

# install dependencies - do not set as ENV 
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive TZ=America/New_York \
	apt-get install --yes vim less net-tools make wget libboost-all-dev libdb5.3++-dev libevent-dev libminiupnpc-dev

# create a non-root user
RUN adduser --disabled-login --gecos "" tester

# run following commands from user's home directory
WORKDIR /home/tester

ENV CORE_URL "https://github.com/ayyo2765/testnet-box/raw/radiant/radiant-v1.2.0.tar.gz"

# download and install binaries
RUN mkdir tmp \
	&& cd tmp \
	&& wget "${CORE_URL}" \
	&& tar xzf "$(basename ${CORE_URL})" \
	&& cd "$(basename -s .tar.gz ${CORE_URL})/bin" \
	&& install --mode 755 --target-directory /usr/local/bin *

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
USER tester

# run commands from inside the testnet-box directory
WORKDIR /home/tester/testnet-box

# expose two rpc ports for the nodes to allow outside container access
EXPOSE 19001 19011
CMD ["/bin/bash"]
