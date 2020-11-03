FROM cern/cc7-base
RUN yum install -y git make gcc which python3 iperf3
RUN python3 -m pip install numpy matplotlib
RUN git clone -b dockerfile https://github.com/centipeda/soc-benchmark.git
RUN ls soc-benchmark

# CMD cd soc-benchmark && ./run-benchmarks.sh -j localhost results
CMD iperf3 -c centipeda.cc > results.txt
