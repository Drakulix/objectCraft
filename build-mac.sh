#!/bin/bash
/opt/local/bin/autoreconf
./configure --with-objfw-include-path=./build-mac --with-objfw-lib-path=./build-mac
make
install_name_tool -change /Users/Drakulix/Downloads/objfw-HEAD-34192c5/usr/lib/libobjfw.7.dylib @executable_path/libobjfw.dylib objectCraft
rm ./build-mac/objectCraft
mv objectCraft ./build-mac/objectCraft