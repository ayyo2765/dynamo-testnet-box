# dynamo-testnet-box docker image

FROM ubuntu:bionic

# install dependencies - do not set as ENV 
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive TZ=America/New_York \
	apt-get install --yes vim make wget net-tools libboost-all-dev libdb5.3++-dev libevent-dev

# create a non-root user
RUN adduser --disabled-login --gecos "" tester

# run following commands from user's home directory
WORKDIR /home/tester

ENV DYNAMO_CORE_VERSION "21.99.0"

# download and install dynamo binaries
RUN mkdir tmp \
	&& cd tmp \
	&& wget "https://github.com/ayyo2765/dynamo-testnet-box/raw/master/dynamo-test-${DYNAMO_CORE_VERSION}-x86_64-linux-gnu.tar.gz" \
	&& tar xzf "dynamo-test-${DYNAMO_CORE_VERSION}-x86_64-linux-gnu.tar.gz" \
	&& cd "dynamo-test-${DYNAMO_CORE_VERSION}/bin" \
	&& install --mode 755 --target-directory /usr/local/bin *

# clean up
RUN rm -r tmp

# copy the testnet-box files into the image
ADD . /home/tester/dynamo-testnet-box

# make tester user own the dynamo-testnet-box
RUN chown -R tester:tester /home/tester/dynamo-testnet-box

# color PS1
RUN mv /home/tester/dynamo-testnet-box/.bashrc /home/tester/ && \
	cat /home/tester/.bashrc >> /etc/bash.bashrc

# use the tester user when running the image
USER tester

# run commands from inside the testnet-box directory
WORKDIR /home/tester/dynamo-testnet-box

# expose two rpc ports for the nodes to allow outside container access
EXPOSE 19001 19011
CMD ["/bin/bash"]
