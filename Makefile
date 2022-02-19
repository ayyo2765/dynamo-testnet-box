DYNAMOD_TEST=dynamod-test
DYNAMO_CLI_TEST=dynamo-cli-test
B1_FLAGS=
B2_FLAGS=
B1=-datadir=1 $(B1_FLAGS)
B2=-datadir=2 $(B2_FLAGS)
BLOCKS=1
ADDRESS=
AMOUNT=
ACCOUNT=

start:
	$(DYNAMOD_TEST) $(B1) -daemon
	$(DYNAMOD_TEST) $(B2) -daemon

generate:
	$(DYNAMO_CLI_TEST) $(B1) -generate $(BLOCKS)

getinfo:
	$(DYNAMO_CLI_TEST) $(B1) -getinfo
	$(DYNAMO_CLI_TEST) $(B2) -getinfo

sendfrom1:
	$(DYNAMO_CLI_TEST) $(B1) sendtoaddress $(ADDRESS) $(AMOUNT)

sendfrom2:
	$(DYNAMO_CLI_TEST) $(B2) sendtoaddress $(ADDRESS) $(AMOUNT)

address1:
	$(DYNAMO_CLI_TEST) $(B1) getnewaddress $(ACCOUNT)

address2:
	$(DYNAMO_CLI_TEST) $(B2) getnewaddress $(ACCOUNT)

stop:
	$(DYNAMO_CLI_TEST) $(B1) stop
	$(DYNAMO_CLI_TEST) $(B2) stop

clean:
	find 1/* -not -name 'dynamo.conf' -delete
	find 2/* -not -name 'dynamo.conf' -delete

docker-build:
	docker build --tag dynamo-testnet-box .

docker-run:
	docker run -it --rm -p 19001:19001 -p 19011:19011 --name dynamo-testnet-box dynamo-testnet-box
