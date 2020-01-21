#!/bin/bash

for n in {0..10}
do  
    echo "Run #$n beginning..."
    make clean && make XCFLAGS="-O3 -march=armv7-a -mcpu=cortex-a9 -mfpu=neon-fp16 -march=armv7-a -DMULTITHREAD=2 -DUSE_PTHREAD -lpthread -lrt"
    tail -n 1 run1.log >> results.txt
    echo "Run #$n finished."
done

