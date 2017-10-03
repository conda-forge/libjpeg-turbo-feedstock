#!/bin/bash

autoreconf -fiv

# Set here any HW specific flags (usually at CFLAGS)
./configure --prefix=$PREFIX \
    --enable-shared=yes \
    --enable-static=yes \
    --with-jpeg8 \
    CFLAGS="-O3 -fPIC" \
    NASM=yasm
make
make check
make install
