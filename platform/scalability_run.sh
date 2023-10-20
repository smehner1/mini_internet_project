#! /bin/bash

# Author: Max Bergmann

PYTHON="/home/max/WORK/masterthesis/miniconda3/envs/mini/bin/python3"

AS=$1
sleep 3

# generate configs for mini-internet
$PYTHON /home/max/WORK/masterthesis/mini_internet_tools/scalability/create_mini_internet_configs.py $AS

# startup mini-internet
startup_start=`date +%s%N`
./startup.sh
startup_end=`date +%s%N`

startuptime=$((startup_end-startup_start))
echo ${AS},STARTUP_START,${startup_start} >> step_log.log
echo ${AS},STARTUP_END,${startup_end} >> step_log.log
echo ${AS},STARTUP_TIME,${startuptime} >> step_log.log

# configure mini-internet
conf_start=`date +%s%N`
$PYTHON configurator/configure.py
conf_end=`date +%s%N`

configtime=$((conf_end-conf_start))
echo ${AS},CONFIG_START,${conf_start} >> step_log.log
echo ${AS},CONFIG_END,${conf_end} >> step_log.log
echo ${AS},CONFIG_TIME,${configtime} >> step_log.log

# generate 1 hour traffic
start=`date +%s%N`
/home/max/WORK/masterthesis/mini_internet_tools/traffic_generator/generate_day_traffic.sh
end=`date +%s%N`

generationtime=$((end-start))
echo ${AS},GEN_START,${start} >> step_log.log
echo ${AS},GEN_END,${end} >> step_log.log
echo ${AS},GEN_TIME,${generationtime} >> step_log.log

# echo ${AS},${startup_start},${startup_end},${startuptime},${conf_start},${conf_end},${configtime},${start},${end},${generationtime} >> step_log.log
