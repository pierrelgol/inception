#!/bin/bash

# List all Docker image IDs and remove each one
docker image ls -q | while read -r image_id; do
    echo "Removing image ID: $image_id"
    docker image rm "$image_id" --force
done
