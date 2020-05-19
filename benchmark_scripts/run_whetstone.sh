#!/bin/bash
LOOPS=1000000

for n in {1..10}
do  
    echo "Performing run #$n..."
    ./whetstone $LOOPS | tail -n 1 >> results.txt
done
