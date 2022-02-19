# dynamo-testnet-box

Create your own private dynamo testnet docker container

# Required host packages

```
$ apt install make guile-2.2 libgc-dev
```

## Building dynamo-testnet-box image

```
$ make docker-build
```

## Starting dynamo-testnet-box container

```
$ make docker-run
```


## Starting the testnet 

This will start up two nodes using the two datadirs `1` and `2`. They
will only connect to each other in order to remain an isolated private testnet.
Two nodes are provided, as one is used to generate blocks and it's balance
will be increased as this occurs (imitating a miner). You may want a second node
where this behavior is not observed.

Node `1` will listen on port `19000`, allowing node `2` to connect to it.

Node `1` will listen on port `19001` and node `2` will listen on port `19011`
for the JSON-RPC server.

```
$ make start
```

## Check the status of the nodes

```
$ make getinfo
dynamo-cli-test -datadir=1  -getinfo
{
  "version": 219900,
  "blocks": 0,
  "headers": 0,
  "verificationprogress": 1,
  "timeoffset": 0,
  "connections": {
    "in": 1,
    "out": 0,
    "total": 1
  },
  "proxy": "",
  "difficulty": 1.52587890625e-05,
  "chain": "main",
  "relayfee": 0.00001000,
  "warnings": "This is a pre-release test build - use at your own risk - do not use for mining or merchant applications"
}
dynamo-cli-test -datadir=2  -getinfo
{
  "version": 219900,
  "blocks": 0,
  "headers": 0,
  "verificationprogress": 1,
  "timeoffset": 0,
  "connections": {
    "in": 0,
    "out": 1,
    "total": 1
  },
  "proxy": "",
  "difficulty": 1.52587890625e-05,
  "chain": "main",
  "relayfee": 0.00001000,
  "warnings": "This is a pre-release test build - use at your own risk - do not use for mining or merchant applications"
}
```
## Creating wallets

```
dynamo-cli-test -datadir=1 createwallet wallet1
```

```
dynamo-cli-test -datadir=2 createwallet wallet2
```

## Generating blocks

Normally on the live, real, dynamo network, blocks are generated, on average,
every 10 minutes. Since this testnet-in-box uses Dynamo Core's (dynamod)
regtest mode, we are able to generate a block on a private network
instantly using a simple command.

To generate a block:

```
$ make generate
```

To generate more than 1 block:

```
$ make generate BLOCKS=10
```

## Need to generate at least 100 blocks before there will be a balance in the first wallet
```
$ make generate BLOCKS=200
```

## Verify that there is a balance on the first wallet
```
$ make getinfo
```

## Generate a wallet address for the second wallet
```
$ make address2
```

## Sending dynamo
To send dynamo that you've generated to the second wallet: (be sure to change the ADDRESS value below to wallet address generated in the prior command)

```
$ make sendfrom1 ADDRESS=dyq1... AMOUNT=10
```

## Does the balance show up?
Run the getinfo command again. Does the balance show up? Why not?
```
$ make getinfo
```

## Generate another block
```
$ make generate
```

## Stopping the testnet-box

```
$ make stop
```

To clean up any files created while running the testnet and restore to the
original state:

```
$ make clean
```
