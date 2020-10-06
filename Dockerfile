FROM cern/cc7-base
CMD echo "nameserver 8.8.8.8" >> /etc/resolv.conf
CMD echo "search localhost" >> /etc/resolv.conf
CMD cat /etc/resolv.conf
RUN yum install -y git
RUN echo "testing"
