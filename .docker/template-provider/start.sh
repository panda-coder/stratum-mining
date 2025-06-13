#!/bin/env bash

# Start bitcoind in regtest mode with the specified config file
/app/bitcoin-sv2/bin/bitcoind -regtest -sv2 -sv2bind=0.0.0.0:8442 -debug=sv2 -conf=/app/cfg/bitcoin.conf &
bitcoind_pid=$! # Capture the PID of the backgrounded bitcoind process

# Wait for bitcoind to start (adjust sleep time as needed)
sleep 5

if [ -d "/app/data/regtest/wallets/testwallet" ]; then
    echo "Directory exists"
else
    /app/bitcoin-sv2/bin/bitcoin-cli -regtest -rpcport=18443 -rpcuser=username -rpcpassword=password createwallet "testwallet"
    /app/bitcoin-sv2/bin/bitcoin-cli -regtest  -rpcport=18443 -rpcuser=username -rpcpassword=password -generate 100
fi

#/app/bitcoin-sv2/bin/bitcoin-cli -regtest -rpcport=18443 -rpcuser=username -rpcpassword=password loadwallet "testwallet"

# Wait for bitcoind to exit (optional)
wait $bitcoind_pid

exit 0