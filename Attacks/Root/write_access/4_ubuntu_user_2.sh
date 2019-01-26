#!/bin/sh

echo "Let's see if the attacker wrote in /etc directory:"
ls -l /etc | grep Hello

