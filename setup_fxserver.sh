#!/bin/bash

echo -e "\e[34mAutomatic FXServer Setup Script for Ubuntu 16.04 LTS"
echo
echo Author: d0p3t
echo Twitter: https://twitter.com/d0p3t
echo Github: https://github.com/d0p3t
echo
echo Repository: https://github.com/d0p3t/fxserver-setup-script-ubuntu
echo "Current Version: v0.1\e[39m"
echo
echo

echo -e "\e[32mCreating Directories...\e[39m"
if [ ! -d "$HOME/fivem" ]; then
    mkdir "$HOME/fivem"
    echo Created base directory
else
    echo Skipping base directory, already exists
fi
if [ ! -d "$HOME/fivem/temp" ]; then
    mkdir "$HOME/fivem/temp"
    echo Created temp directory
else
    echo Skipping temp directory, already exists
fi
if [ ! -d "$HOME/fivem/server" ]; then
    mkdir "$HOME/fivem/server"
    echo Created server directory
else
    echo Skipping server directory, already exists
fi
if [ ! -d "$HOME/fivem/server-data" ]; then
    mkdir "$HOME/fivem/server-data"
    echo Created server-data directory
else
    echo Skipping server-data directory, already exists
fi
echo -e "\e[32mDone creating directories.\e[39m"

echo -e "\e[32mGrabbing latest FXServer build version...\e[39m"
LATEST_VERSION=`wget -q -O - https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/ | grep '<a href' | tail -1 | grep -Po '(?<=href=").{44}'`
echo Latest FXServer build: $LATEST_VERSION

if [ ! -f "$HOME/fivem/server/latest_version.log" ]; then
    touch "$HOME/fivem/server/latest_version.log"
fi
if [ "$(head -n 1 $HOME/fivem/server/latest_version.log)" != $LATEST_VERSION ]; then
    echo -e "\e[32mDownloading latest build...\e[39m"
    wget -q --show-progress "https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/$LATEST_VERSION/fx.tar.xz" -P "$HOME/fivem/temp"
    echo Finished downloading FXServer
    echo Decompressing FXServer...
    echo -e "\e[93mIgnore warning/error below\e[39m"
    tar -xf "$HOME/fivem/temp/fx.tar.xz" -C "$HOME/fivem/server"
    echo Done decompressing FXServer
    echo $LATEST_VERSION > "$HOME/fivem/server/latest_version.log"
    echo -e "\e[32mSuccessfully installed new FXServer build version $LATEST_VERSION\e[39m"
else
    echo Skipping FXServer, you already have the latest build
fi

if [ ! -d "$HOME/fivem/server-data/resources" ]; then
    echo -e "\e[32mCloning cfx-server-data to $HOME/fivem_test/server-data\e[39m"
    git clone https://github.com/citizenfx/cfx-server-data.git "$HOME/fivem/server-data"
    echo -e "\e[32mDone cloning cfx-server-data\e[39m"
else
    echo Found existing resources folder, skipping cloning cfx-server-data
fi

if [ ! -f "$HOME/fivem/server-data/server.cfg" ]; then
    echo -e "\e[32mCreating server.cfg...\e[39m"
    wget -q --show-progress "https://gist.githubusercontent.com/d0p3t/09d9ff1dc93d2534e7eb7c2712b163a9/raw/a382d32ad3e186bef85322eda52bd44bcb10e5e2/server.cfg" -P "$HOME/fivem/server-data"
    echo -e "\e[32mDone creating server.cfg in $HOME/fivem/server-data\e[39m"
    echo -e "Don't forget to add your license key to 'server.cfg'!"
else
    echo Found existing server.cfg, skipping creating server.cfg
fi


rm -rf "$HOME/fivem/temp"
echo -e "Deleted temp folder"

echo -e "\e[32mCompleted FXServer Setup!\e[39m"
echo
echo -e "Instructions to start server"
echo "1. 'cd $HOME/fivem/server-data'"
echo "2. 'bash $HOME/fivem/server/run.sh +exec server.cfg'"
echo
echo "Enjoy!"
echo