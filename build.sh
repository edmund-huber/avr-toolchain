#!/bin/bash
set -euo pipefail

git submodule init
git submodule sync
git submodule update

# These instructions copied from http://www.ladyada.net/learn/avr/setup-unix.html .

if [ ! command -v avr-addr2line >/dev/null 2>&1 ]; then
    cd binutils-gdb
    ./configure --target=avr --program-prefix="avr-"
    make
    sudo make install
    cd ..
fi

if [ ! command -v avr-gcc >/dev/null 2>&1 ]; then
    mkdir build-gcc
    cd build-gcc
    ../gcc/configure --target=avr --program-prefix="avr-" --enable-languages=c --disable-libssp
    make
    sudo make install
    cd ..
fi

rm -rf avr-libc
mkdir avr-libc
tar xjf avr-libc-2.0.0.tar.bz2 -C avr-libc --strip-components 1
cd avr-libc
./configure --host=avr
make
sudo make install
cd ..
