#!/usr/bin/env zsh
trap "exit" SIGTERM SIGINT

echo
echo "----------------------------------------"
echo "Zondax YOCTO container - zondax.ch"
echo "----------------------------------------"
echo

# ADD ANYTHING HERE TO CUSTOMIZE CONTAINER START UP
sudo chsh -s $(which zsh)

source $HOME/.cargo/env

zsh -c "trap 'exit' SIGTERM SIGINT; $@"
