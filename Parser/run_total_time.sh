#!/bin/bash

source timer.sh

t=$(timer)

./SecureWilly_UI.sh < input_sample

total=$(timer $t)
echo "${total}" > total_sw_time
