#!/bin/bash

source openrc 

set -ex

# Upload a large file to Swift, generate a tempurl for it, then use this to
# download it.

# Create a large file
truncate -s 2G big-file
swift upload test-container big-file

# Grab the project ID
project_id=$(openstack project show demo | awk '$2 == "id" { print $4 }')
echo "Project ID is $project_id"

# Set a tempurl key
key=$(sudo cat /vagrant/swift-tempurl-key)
swift post -m "Temp-URL-Key:$key"
echo "Using tempurl key $key"

# Create a tempurl
path="$(swift tempurl GET 36000 /v1/AUTH_${project_id}/test-container/big-file $key)"
url="http://localhost:8080${path}"
echo "Tempurl is $url"

# Stat the tempurl (-I is HEAD)
curl -I $url

tracker=http://10.0.2.2:9000/announce
rm -f big-file-seed.torrent big-file-leech.torrent
mktorrent -a $tracker -o big-file-seed.torrent -w $url big-file
mktorrent -a $tracker -o big-file-leech.torrent big-file

mkdir -p leech seed

(cd seed &&
 /vagrant/libtorrent-downloader.py \
   ../big-file-seed.torrent) > seed.log &

(cd leech &&
 /vagrant/libtorrent-downloader.py \
   ../big-file-leech.torrent) > leech.log &

wait

echo "Torrenting finished."
echo "Seed log:"
cat seed.log
echo "Leech log:"
cat leech.log
