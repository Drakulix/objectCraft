#!/bin/bash
aclocal -I m4 || exit 1
autoconf || exit 1
autoheader || exit 1
automake || exit 1