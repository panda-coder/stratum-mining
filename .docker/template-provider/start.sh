#!/bin/env bash

# Start bitcoind in regtest mode with the specified config file
/app/bitcoin-sv2/bin/bitcoind -regtest -sv2 -sv2bind=0.0.0.0:8442 -debug=sv2 -conf=/app/cfg/bitcoin.conf &
bitcoind_pid=$! # Capture the PID of the backgrounded bitcoind process

# Wait for bitcoind to start (adjust sleep time as needed)
sleep 5

# Create the wallet
/app/bitcoin-sv2/bin/bitcoin-cli -regtest -rpcport=18443 -rpcuser=username -rpcpassword=password createwallet "testwallet"

# Generate blocks
/app/bitcoin-sv2/bin/bitcoin-cli -regtest  -rpcport=18443 -rpcuser=username -rpcpassword=password -generate 100

# Wait for bitcoind to exit (optional)
wait $bitcoind_pid

exit 0