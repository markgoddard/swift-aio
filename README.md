Swift AIO
=========

All-in-one Swift and Keystone deployment in DevStack.

Byte Ranges
-----------

http://developer.openstack.org/api-ref/object-storage/?expanded=get-object-content-and-metadata-detail

See Range header.

Example:

swift download <container> <object> -o - -H 'Range: bytes=2-10,-5' --ignore-checksum
