#!/bin/bash

# Check byte ranges
source openrc 
swift list
swift upload test-container README.md 
swift list
swift list test-container
swift download test-container README.md -o - -H 'Range: bytes=2-10,-5' --ignore-checksum

# Set a tempurl key
swift --debug post -m "Temp-URL-Key:$(uuidgen)"

# Create a tempurl
swift tempurl GET 3600 /v1/AUTH_334e7f12e85e402f955fe31549b9f3aa/test-container/README.md 02814c5a-ee3f-4957-8d32-b57710419cf6
curl 'http://localhost:8080/v1/AUTH_334e7f12e85e402f955fe31549b9f3aa/test-container/README.md?temp_url_sig=46bd15c957340f4680f5d70eebcc33b380029282&temp_url_expires=1481559133'
