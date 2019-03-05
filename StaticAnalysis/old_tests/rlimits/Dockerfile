FROM fani/test_no0:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>
RUN mkdir /test_proc
RUN chmod 444 /hello
RUN chown root:users /hello
COPY ./test /test_proc/.
WORKDIR /test_proc
ENTRYPOINT /bin/bash
