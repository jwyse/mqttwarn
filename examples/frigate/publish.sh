#!/bin/bash

# Check prerequisites.
prerequisites="cat convert jq mosquitto_pub wget"
for program in ${prerequisites}; do
  if [ ! "$( command -v "${program}" )" ]; then
    echo "ERROR: Program not installed: ${program}"
    exit 1
  fi
done

# Acquire image for publishing.
if [ ! -f goat.jpg ]; then
  wget -O goat.png https://user-images.githubusercontent.com/453543/231550862-5a64ac7c-bdfa-4509-86b8-b1a770899647.png
  convert goat.png goat.jpg
fi

# 1. Publish picture snapshot in JPEG format.
mosquitto_pub -f goat.jpg -t 'frigate/cam-testdrive/goat/snapshot'

# 2. Publish event in JSON format.
# shellcheck disable=SC2002
cat "frigate-event-new.json" | jq -c | mosquitto_pub -t 'frigate/events' -l
