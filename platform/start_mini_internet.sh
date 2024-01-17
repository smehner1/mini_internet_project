#! /bin/bash

./startup.sh
./startup_additional_scripts.sh kill
./startup_additional_scripts.sh

../../miniconda3/envs/mini/bin/python3 configurator/configure.py
