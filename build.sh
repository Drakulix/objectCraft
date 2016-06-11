#!/bin/bash
cd "$( dirname "$0" )"
bash autogen.sh
./configure $*
make
