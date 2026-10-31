#!/bin/ash
sleep 1

cd /home/container || exit 1

# Replace Startup Variables
MODIFIED_STARTUP=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval "${MODIFIED_STARTUP}"
