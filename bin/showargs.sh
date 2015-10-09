#!/bin/bash

# this is just a simple test to make sure arg are getting passed correctly quoted

echo "bash args:"
echo args: $@
echo args split:
for p in "$@";
do
    echo '  ' $p
done
