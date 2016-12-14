import libtorrent
import sys


def decode(filename):
    with open(filename, 'rb') as f:
        return libtorrent.bdecode(f.read())


def encode(content, filename):
    with open(filename, 'wb') as f:
        f.write(libtorrent.bencode(content))


def main():
    assert len(sys.argv) == 3
    filename1 = sys.argv[1]
    filename2 = sys.argv[2]
    content = decode(filename1)
    del content['announce']
    encode(content, filename2)


if __name__ == "__main__":
    main()
