FROM cern/cc7-base
# RUN echo "nameserver 8.8.8.8" >> /etc/resolv.conf
RUN yum install git
RUN echo "testing"
