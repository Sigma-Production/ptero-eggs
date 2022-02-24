#!/bin/ash

UMASK_SET=${UMASK_SET:-022}
umask "$UMASK_SET"

cd /

export DEEMIX_DATA_DIR=/home/container/config/
export DEEMIX_MUSIC_DIR=/home/container/downloads/
export DEEMIX_SERVER_PORT=$1
export DEEMIX_HOST=0.0.0.0

echo "[services.d] Starting Deemix"
node /home/container/server/dist/app.js
