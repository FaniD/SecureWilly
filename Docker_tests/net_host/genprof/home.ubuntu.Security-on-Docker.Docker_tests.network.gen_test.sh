# Last Modified: Mon Oct 15 21:32:23 2018
#include <tunables/global>

/home/ubuntu/Security-on-Docker/Docker_tests/network/gen_test.sh {
  #include <abstractions/apache2-common>
  #include <abstractions/base>
  #include <abstractions/bash>

  /bin/dash ix,
  /home/ubuntu/Security-on-Docker/Docker_tests/network/gen_test.sh r,
  /proc/sys/net/core/somaxconn r,
  /usr/bin/docker r,

}
