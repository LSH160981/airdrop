#!/bin/bash

WORKER=$(curl -s https://api.ipify.org)

if [ -n "$CUSTOM_WORKER" ]; then
    WORKER=$CUSTOM_WORKER
fi

if ps aux | grep 'apoolminer' | grep -q 'apool.io'; then
    echo "ApoolMiner already running."
    exit 1
else
    nohup ./apoolminer --account CP_6i7k2ek920 --worker $WORKER --gpu-off --pool qubic1.hk.apool.io:3334 >> qubic.log 2>&1 &
fi
