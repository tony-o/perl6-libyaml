#!/bin/bash

cd src 

gcc -c -fPIC yamlwrap.c -o yamlwrap.o
gcc -shared -Wl,-soname,yamlwrap.so.1 -lyaml -o yamlwrap.so.1.0.0 yamlwrap.o

cd ..

echo 'If you'"'"'re running locally you may need to add this dir to LD_LIBRARY_PATH'
echo '  to do that, run: export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:'`pwd`'"'
 
