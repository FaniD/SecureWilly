FROM ubuntu:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>

#Create userA with password A
RUN useradd -m userA && echo "userA:A" | chpasswd
RUN mkdir /test_proc

#Run as userA
USER userA

#Add exe file to test nproc
COPY test /test_proc/
COPY check_nproc.sh /test_proc
WORKDIR /test_proc

#CMD ["./test"]

#If I want to run interactive mode, 
#the following command must be used instead of CMD
#Some options must be added in .yml file as well (see .yml file)
#Then I can open a new terminal and run:
#docker exec -ti <container ID> /bin/bash
#Run in the new terminal the test exe:
#./test
#Again open a new terminal and exec container to see the processes
#as they increase by fork by running command:
#ps h -Lu userA | wc -l

ENTRYPOINT /bin/bash

