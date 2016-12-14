import libtorrent


def decode(filename):
    with open(filename, 'rb') as f:
        return libtorrent.bdecode(f.read())


def encode(content, filename):
    with open(filename, 'wb') as f:
        f.write(libtorrent.bencode(content))


def main():
    content = decode('big-file-leech.torrent')
    del content['announce']
    content['nodes'] = [
        ['10.0.2.15', 6001], ['10.0.2.15', 6002]
    ]
    encode(content, 'big-file-leech2.torrent')


if __name__ == "__main__":
    main()
