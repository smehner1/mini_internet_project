#!/bin/bash
#
# remove all container, bridges and temporary files
# will only remove the containers, bridges defined in ../config/

set -o errexit
set -o pipefail
set -o nounset

if [ "$#" != 1 ]; then
  echo "usage: ${0##*/} directory" 2>&1
  exit 1
fi

DIRECTORY="$1"

# kill all container
./cleanup/container_cleanup.sh "${DIRECTORY}"

# WARNING: remove all stopped containers, unused networks, dangling images, unused build cache & restart docker
docker system prune

echo -n "ovs-vsctl " > ovs_command.txt

./cleanup/host_links_cleanup.sh "${DIRECTORY}"
./cleanup/layer2_cleanup.sh "${DIRECTORY}"
./cleanup/internal_links_cleanup.sh "${DIRECTORY}"
./cleanup/external_links_cleanup.sh "${DIRECTORY}"
./cleanup/measurement_cleanup.sh "${DIRECTORY}"
./cleanup/matrix_cleanup.sh "${DIRECTORY}"
./cleanup/dns_cleanup.sh "${DIRECTORY}"
./cleanup/ssh_cleanup.sh "${DIRECTORY}"
./cleanup/vpn_cleanup.sh "${DIRECTORY}"


bash  < ovs_command.txt || true
rm -f ovs_command.txt

# delete old running config files
if [ -e groups ]; then
  rm -rf groups
fi
