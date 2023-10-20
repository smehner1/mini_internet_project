#! /bin/bash

# Author: Max Bergmann

PYTHON="/home/max/WORK/masterthesis/miniconda3/envs/mini/bin/python3"

# echo ASes,START,END,TIME >> time_log.txt
# echo ASes,STARTUP_START,STARTUP_END,STARTUP_TIME,CONF_START,CONF_END,CONF_TIME,GEN_START,GEN_END,GEN_TIME >> step_log.txt

# for num in {10..100..10}
# for num in 5 10 30 50 80 100
for num in 10 30 50 80 100
do
    echo start with $num ASes
    $PYTHON log_ressources.py $num &
    start=`date +%s%N`
    ./scalability_run.sh $num
    end=`date +%s%N`

    time=$((end-start))
    line="$num,$start,$end,$time"

    echo $line >> time_log.log
    ps -ef | grep log_ressources.py | grep -v grep | awk '{print $2}' | xargs kill

done