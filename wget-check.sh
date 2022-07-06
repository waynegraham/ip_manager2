#!/bin/bash
while read LINE; do
    wget --server-response --spider --quiet "$LINE" 2>&1 | awk 'NR==1{print $2}'
done < urls.txt