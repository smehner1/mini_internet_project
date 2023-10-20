#!/usr/bin/python3
import os
import sys
import time

from datetime import datetime

__author__ = 'Max Bergmann'

ases: int = sys.argv[1]

if __name__ == '__main__':
    starttime: datetime = time.monotonic()
    interval_time: int = 60

    while True:
        # log the used ressources per minute (RAM & CPU)
        os.popen(f'bash ./log_ressources.sh {ases}')

        waiting = interval_time - ((time.monotonic() - starttime) % interval_time)
        time.sleep(waiting)
