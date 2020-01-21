#!/bin/bash
RUNS=10
ITERS=100000000

echo "Running gcc_dry2"
echo "gcc_dry2:" >> results.txt
for i in $( seq 1 $RUNS )
do
        echo "performing run #$i..."
        echo $ITERS | ./gcc_dry2 | tail -n 2 | head -n 1 >> results.txt
done

echo "Running gcc_dry2reg"
echo "" >> results.txt
echo "gcc_dry2reg:" >> results.txt
for i in $( seq 1 $RUNS )
do
        echo "performing run #$i..."
        echo $ITERS | ./gcc_dry2reg | tail -n 2 | head -n 1 >> results.txt
done
