#!/bin/sh

cd /scratch/mini-internet-connectivity-matrix-history

curl --silent "http://mittelerde.informatik.tu-cottbus.de/matrix/" |\
grep -v "This connectivity matrix indicates the networks that each group can" > matrix.html

git add matrix.html > /dev/null
git commit -m "Matrix update" > /dev/null

echo "connectivitiy matrix commited - sleep for 5min"
sleep 300