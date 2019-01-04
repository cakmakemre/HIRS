#!/bin/bash

# Script to run the Integration Tests for HIRS

set -e

# Start Integration Testing Docker Environment
cp .ci/docker/.env .
docker-compose -f .ci/docker/docker-compose.yml up -d

#cp ../docker/.env .
#docker-compose -f ../docker/docker-compose.yml up -d

#aca_container_id="$(docker ps -aqf "name=hirs-aca")"
#echo "ACA Container id: $aca_container_id"

tpm2_container_id="$(docker ps -aqf "name=hirs-aca-provisioner-tpm2")"
echo "TPM2 Container id: $tpm2_container_id"

tpm2_container_status="$(docker inspect $tpm2_container_id --format='{{.State.Status}}')"
echo "TPM2 Container Status: $tpm2_container_status"

#tpm2_container_running="$(docker inspect $tpm2_container_id --format='{{.State.Running}}')"
#echo "TPM2 Container Running: $tpm2_container_running"

while [ $tpm2_container_status == "running" ] 
do
#  echo "TPM2 Container Status: $tpm2_container_status"
#  echo "hirs-aca-provisioner-tpm2 is still running..."

  sleep 5 

  tpm2_container_status="$(docker inspect $tpm2_container_id --format='{{.State.Status}}')"
done

echo "TPM2 Container Status: $tpm2_container_status"
echo "hirs-aca-provisioner-tpm2 Exited!!"

#echo ""
#echo "hirs-aca Test Log:"
#docker logs $aca_container_id
echo ""
echo "hirs-aca-provisioner-tpm2 Test Log:"
docker logs $tpm2_container_id

echo ""
echo "End of Systems Test, cleaning up..."
cd .ci/docker
#cd ../docker
docker-compose down
#docker-compose logs -f

# Check to see if Environment Stand-Up is Complete
# TODO: Refine to handle multiple container IDs
#container_id_regex='([a-f0-9]{12})\s+hirs\/hirs-ci:tpm2provisioner'
#while : ; do
#    docker_containers=$(docker container ls)
#    if [[ $docker_containers =~ $container_id_regex ]]; then
#        container_id=${BASH_REMATCH[1]}
#        break
#    fi
#    echo "Containers not found. Waiting 5 seconds."
#    sleep 5
#done
#
#tpm2_provisioner_started_regex='TPM2 Provisioner Loaded!'
#while : ; do
#    docker_logs=$(docker logs $container_id)
#    if [[ $docker_logs =~ $tpm2_provisioner_started_regex ]]; then
#        break
#    fi
#    echo "Containers not completely booted. Waiting 10 seconds."
#    sleep 10
#done
#
#echo "Environment Stand-Up Complete!"
