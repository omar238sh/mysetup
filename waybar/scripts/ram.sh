#!/bin/bash

used=$(free -g | awk '/^Mem:/ {print $3}')
total=$(free -g | awk '/^Mem:/ {print $2}')
percent=$(( used * 100 / total ))
echo "  ${used}G/${total}G (${percent}%)"

