CPU=$(top -b -n4 -p1 | awk '/Cpu/ { print $2}' | tail -1)

echo $CPU
