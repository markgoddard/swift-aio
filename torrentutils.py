import libtorrent


def decode(filename):
    with open(filename, 'rb') as f:
        return libtorrent.bdecode(f.read())


def encode(content, filename):
    with open(filename, 'wb') as f:
        f.write(libtorrent.bencode(content))


def main():
    tempurl = 'http://localhost:8080/v1/AUTH_8283d35046fa4c5f89f72de41b83c699/test-container/big-file?temp_url_sig=65b8b445572064780f4e6543790e22713f6d5ad5&temp_url_expires=1481665347'
    content = decode('big-file.torrent')
    del content['announce']
    content['httpseeds'] = [
        tempurl
    ]
    encode(content, 'big-file2.torrent')

def main():
    content = decode('big-file.torrent')
    content['nodes'] = [
        ['10.0.2.15', 6001], ['10.0.2.15', 6002]
    ]
    encode(content, 'big-file2.torrent')


if __name__ == "__main__":
    main()
