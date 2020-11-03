#!/bin/bash
# run run-benchmarks.sh network benchmarks through docker containers, then copy the results

function usage {
    echo "$0: run run-benchmarks through docker containers"
    echo "usage: $0 [-n num_containers] iperf_server"
    exit 0
}

N_CONTAINERS=1
IPERF_SERVER="localhost"
while [ $# -gt 0 ] ; do 
    case $1 in
        -n)
            shift
            N_CONTAINERS=$1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            IPERF_SERVER=$1
            ;;
    esac
    shift
done

if [[ $(docker ps -a -q) ]] ; then
    docker rm $(docker ps -a -q)
fi

for n in { 1 .. $N_CONTAINERS }
do
    docker run --network="host" benchmark:latest &
done

while [[ ! $(docker ps -q) ]]
do 
    sleep 1
done

mkdir docker_results
IDS=$(docker container ps -a | grep benchmark:latest | cut -d" " -f 1)
for id in $IDS
do
    docker cp $id:/results.txt ./docker_results/$id-results.txt
done