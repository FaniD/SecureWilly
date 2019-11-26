#!/bin/bash

see=$(cat mysql_error_exec | grep 'ERROR')
while [ ! -z "$see" ] 
do
  echo "Mpike me ${see}"
done

