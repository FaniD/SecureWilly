FROM fani/test_no0:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>
#RUN mkdir /hello
RUN chmod 444 /hello
RUN chown root:users /hello
#COPY ./ hello
#RUN useradd -ms /bin/bash newuser
#RUN adduser --disabled-password '' newuser
#RUN useradd -m docker && echo "docker:docker" | chpasswd
#USER docker
CMD while true; do echo 'hello world' | nc -l -p 2048; done
#aENTRYPOINT /bin/bash
