#!/bin/bash

source openrc 

set -ex

# Upload a small file to Swift, then download specific byte ranges of the file.
# Check byte ranges
echo "Hello, world" > /tmp/test-obj
swift upload test-container /tmp/test-obj --object-name test-obj
swift download test-container test-obj -o - -H 'Range: bytes=0-5,-5' --ignore-checksum
