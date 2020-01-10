#!/usr/bin/env bash
trap "exit" SIGTERM SIGINT

echo
echo "--------------------------------------"
echo "Zondax OPTEE container - zondax.ch"
echo "--------------------------------------"
echo

#source /home/test/.cargo/env

echo
bash -c "trap 'exit' SIGTERM SIGINT; $@"
