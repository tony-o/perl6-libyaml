#!/bin/bash

cd clib

gcc -c -fPIC libyaml_wrap.c -o libyaml_wrap.o
gcc -shared -W1,-soname,libyaml_wrap.so.1 -lyaml -o libyaml_wrap.so.1.0.0 libyaml_wrap.o

cd ..

echo 'If you'"'"'re running locally you may need to add this dir to LD_LIBRARY_PATH'
echo '  to do that, run: export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:'`pwd`'"'
 
