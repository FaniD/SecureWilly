#!/bin/sh

#chmod a+s: a:all users, +s:If someone else runs the file, they will run the file as the user/group who created it.
docker run --rm -it -v /bin/:/attack_bin ubuntu /bin/bash

