#!/bin/sh

for f in img/*; do
    name=`basename "$f"`
    grep "$name" bookinfo/* 2>&1 >/dev/null
    if test "$?" != 0; then 
        echo "$f"; 
    fi; 
done
