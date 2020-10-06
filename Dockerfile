FROM cern/cc7-base
# RUN echo "nameserver 8.8.8.8" >> /etc/resolv.conf
# RUN yum install git gcc
RUN echo "testing"
RUN mkdir -p ./benchmark
ADD ./* ./benchmark/
RUN ls -al .
RUN ls -al ./benchmark
