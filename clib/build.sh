#!/bin/bash

gcc -c -fPIC libyaml_wrap.c -o libyaml_wrap.o
gcc -shared -W1,-soname,libyaml_wrap.so.1 -lyaml -o libyaml_wrap.so.1.0.0 libyaml_wrap.o

