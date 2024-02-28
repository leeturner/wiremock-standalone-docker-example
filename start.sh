#!/usr/bin/env bash

# first parameter with default value
PORT=${1:-8080}

LOCAL_EXTENSIONS_DIR=$PWD/wiremock/extensions
LOCAL_MAPPINGS_DIR=$PWD/wiremock/mappings
LOCAL_FILES_DIR=$PWD/wiremock/__files
DOCKER_EXTENSIONS_DIR=/var/wiremock/extensions
DOCKER_MAPPINGS_DIR=/home/wiremock/mappings
DOCKER_FILES_DIR=/home/wiremock/__files

echo "Mounting local mappings directory: $LOCAL_MAPPINGS_DIR to docker mappings directory: $DOCKER_MAPPINGS_DIR"
echo "Mounting local files directory: $LOCAL_FILES_DIR to docker files directory: $DOCKER_FILES_DIR"
echo "Mounting local extensions directory: $LOCAL_EXTENSIONS_DIR to docker extensions directory: $DOCKER_EXTENSIONS_DIR"
echo ""
echo "Starting Wiremock on port: $PORT"

docker run -it --rm \
  -p "$PORT":"$PORT" \
  --name wiremock \
  -v "$LOCAL_EXTENSIONS_DIR":$DOCKER_EXTENSIONS_DIR \
  -v "$LOCAL_MAPPINGS_DIR":$DOCKER_MAPPINGS_DIR \
  -v "$LOCAL_FILES_DIR":$DOCKER_FILES_DIR \
  wiremock/wiremock:nightly \
  --port "$PORT" --verbose --extensions org.wiremock.RandomExtension