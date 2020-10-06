FROM cern/cc7-base
RUN yum install -y git make gcc which python3
RUN git clone -b master https://github.com/centipeda/soc-benchmark.git
RUN ls soc-benchmark
