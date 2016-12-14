#!/bin/bash

source openrc 

set -ex

# Upload a large file to Swift, generate a tempurl for it, then use this to
# download it.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
NUM_CLIENTS=2
USE_LPD="false"
MAX_DOWNLOAD_LIMIT=0

# Create a large file
truncate -s 2G big-file
swift upload test-container big-file

# Grab the project ID
project_id=$(openstack project show $OS_PROJECT_NAME | awk '$2 == "id" { print $4 }')
echo "Project ID is $project_id"

# Set a tempurl key
key=$(sudo cat ${DIR}/swift-tempurl-key)
swift post -m "Temp-URL-Key:$key"
echo "Using tempurl key $key"

# Create a tempurl
path="$(swift tempurl GET 36000 /v1/AUTH_${project_id}/test-container/big-file $key)"
url="http://localhost:8080${path}"
echo "Tempurl is $url"

# Stat the tempurl (-I is HEAD)
curl -I $url

# Create a .torrent file for the object without a tracker.
tracker=http://10.0.2.2:9000/announce
rm -f big-file.torrent
mktorrent -a $tracker -o big-file.torrent -w $url big-file
python ${DIR}/trackerless.py big-file.torrent big-file-trackerless.torrent

for i in $(seq 1 $NUM_CLIENTS); do
    mkdir -p client$i
    (cd client$i &&
     time aria2c \
       --allow-overwrite \
       --log aria2c.log \
       --log-level info \
       --seed-time 0 \
       --bt-enable-lpd=$USE_LPD \
       --max-download-limit $MAX_DOWNLOAD_LIMIT \
       ../big-file-trackerless.torrent) > client$i/console.log &
    sleep 1
done

echo "Waiting for clients to complete"
time wait

echo "Torrenting finished."
for i in $(seq 1 $NUM_CLIENTS); do
    echo "Client $i log:"
    cat client$i/console.log
done
