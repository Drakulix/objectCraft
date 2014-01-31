#!/bin/bash
./configure $*
make
mkdir ./build-mac
rm ./build-mac/objectCraft
mv objectCraft ./build-mac/objectCraft