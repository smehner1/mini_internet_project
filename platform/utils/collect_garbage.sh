# !/bin/bash

# Author: Max Bergmann


CONDA=$1
PYTHON=${CONDA}/envs/mini/bin/python3

location=$((pwd))
MINIDIR=${location}/../../  # directory of the Mini-Internet
NETFLOWDIR=${location}/../../shared_directories/router_files/netflow_mini-internet  # directory that includes the netflow

INTERVAL=3600  # collect every hour the garbage

# read possible flags, otherwise use default values
while getopts "i:p:m:n" OPTION; do
    case "$OPTION" in
        i)
            ivalue="$OPTARG"
            INTERVAL=$ivalue
            ;;
        p)
            pvalue="$OPTARG"
            PYTHON=$pvalue
            ;;
        m)
            mvalue="$OPTARG"
            MINIDIR=$mvalue
            ;;
        n)
            nvalue="$OPTARG"
            NETFLOWDIR=$nvalue
            ;;
        ?)
            echo "script usage: $(basename \$0) [-i intervaltime] [-p python executable] [-m mini internet directory] [-n netflow directory]" >&2
            exit 1
            ;;
    esac
done
shift "$(($OPTIND -1))"

FILE_PATH="$(dirname -- "${BASH_SOURCE[0]}")"            # relative
FILE_PATH="$(cd -- "$FILE_PATH" && pwd)"    # absolutized and normalized
if [[ -z "$FILE_PATH" ]] ; then
  exit 1  # fail
fi

while :
do
    echo
    start=`date +%s`
    $PYTHON $FILE_PATH/garbage_collector.py \
        --minidir $MINIDIR \
        --netflowdir $NETFLOWDIR \
        -i 1
    end=`date +%s`

    exec_time=$((end-start))
    wait=$((INTERVAL-exec_time))

    echo $wait seconds until next collection

    sleep "${wait}"
done
