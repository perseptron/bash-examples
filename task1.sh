#!/bin/bash

# we are runnig python scripts because for bash it is too complicated
echo "running script"
python3 ./task1.py $1 2>&2
#here we done
echo "Ready"
