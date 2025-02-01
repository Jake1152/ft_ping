from socket import *
import os 
import binascii


def parsing(host):

    # raw socket 생성 
    if os.name=="nt":
        sock_protocol = IPPROTO_IP
    else:
        sock_protocol = IPPROTO_ICMP

    print(f"{os.name=}")
    sock = socket(AF_INET, SOCK_RAW, sock_protocol)
    sock.bind((host, 0))

    sock.setsockopt(IPPROTO_IP, IP_HDRINCL, 1)

    while (1):
        data = sock.recvfrom(65535)
        print(data[0])
        print()
        # ascii_str = binascii.unhexlify(data[0])
        # ascii_text = data[0].decode("ascii", errors="ignore")
        # print(ascii_text)
        # print(ascii_str)
        # print()

    sock.close()

if __name__ == "__main__":
    # host="10.19.209.46"
    host="127.0.0.1"
    print(f"Listening at {host}")
    parsing(host)
        