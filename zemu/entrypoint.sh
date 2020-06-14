#!/usr/bin/env bash
trap "exit" SIGTERM SIGINT

echo
echo "--------------------------------------"
echo "Zemu container - zondax.ch"
echo "--------------------------------------"
echo

echo "HTTP proxy started..."
/home/zondax/speculos/tools/ledger-live-http-proxy.py -v &

echo -e "$(printenv | grep BOLOS)"

echo
bash -c "trap 'exit' SIGTERM SIGINT; $@"
