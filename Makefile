COIN=pulsar

D=$(COIN)d
CLI=$(COIN)-cli
CONFIG=$(COIN).conf

B1_FLAGS=
B2_FLAGS=
B1=-datadir=1 $(B1_FLAGS)
B2=-datadir=2 $(B2_FLAGS)
BLOCKS=1
ADDRESS=
AMOUNT=
ACCOUNT=

start:
	$(D) $(B1) -daemon
	$(D) $(B2) -daemon

generate:
	$(CLI) $(B1) generate $(BLOCKS)

getinfo:
	$(CLI) $(B1) -getinfo
	$(CLI) $(B2) -getinfo

sendfrom1:
	$(CLI) $(B1) sendtoaddress $(ADDRESS) $(AMOUNT) subtractfeefromamount

sendfrom2:
	$(CLI) $(B2) sendtoaddress $(ADDRESS) $(AMOUNT) subtractfeefromamount

address1:
	$(CLI) $(B1) getnewaddress $(ACCOUNT)

address2:
	$(CLI) $(B2) getnewaddress $(ACCOUNT)

stop:
	$(CLI) $(B1) stop
	$(CLI) $(B2) stop

clean:
	find 1/* -not -name \'$(CONFIG)\' -delete
	find 2/* -not -name \'$(CONFIG)\' -delete

docker-build:
	docker build --tag $(COIN)-testnet-box .

docker-temp:
	docker run -it --rm -p 19001:19001 -p 19011:19011 --name $(COIN)-testnet-box $(COIN)-testnet-box
	
docker-run:
	docker run -it -p 19001:19001 -p 19011:19011 --name $(COIN)-testnet-box $(COIN)-testnet-box
	
docker-start:
	docker start -i $(COIN)-testnet-box

docker-rm:
	docker rm $(COIN)-testnet-box