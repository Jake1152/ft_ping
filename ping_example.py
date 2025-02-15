import socket
import struct
import sys
import ipaddress
import time
import threading

ping_response = {}
running:bool

def checksum(data) -> int:
  s = 0; n = len(data) % 2
  for i in range(0, len(data)-n, 2):
    s += int.from_bytes(data[i:i+1], byteorder='big')

  if n : s += int.from_bytes(data[i:i+1], byteorder='big') # 잔여 바이트 처리
  
  while (s >> 16):
    s = (s & 0xFFFF) + (s >> 16)

  s = ~s & 0xFFFF
  return s

def send_icmp(sock:socket.socket, ip:str):
  type = 8
  code = 0
  csum = 0
  icmpid = 0
  seq = 0
  tmp_data = struck.pack("!BBBB", type, code, csum, icmpid, seq)
  csum = checksum(tmp_data)
  real_data = struct.pack("!BBBB", type, code, csum, icmpid, seq)
  sock.sendto(real_data, (ip, 0))

def is_prefix(mask:int) -> bool:
    if mask < 0 or mask > 32:
        return False
    return True


def prefix2range(mask:int) -> int:
    '''
    netmask로 범위 변경
     e.g)
     - 22 -> 1024
     - 24 -> 256
    '''
    if is_prefix(mask) == False:
        return 0
    inverse = 32 - mask
    return 1 << inverse

def print_usage():
    print("wrong command.\n"
            "usgae: ping_example <ip[/prefix]>\n"
            "e.g  : ping_example 8.8.8.8\n"
            "e.g  : ping_example 192.168.0.0/24\n")

def ping_listen_thread():
    sock = socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_ICMP)
    sock.bind(("0.0.0.0", 0))
    while True:
        data, address = sock.recvfrom(1500)
        if address[0] in ping_response:
            ping_response[address[0]] = True

def main():
    sock = socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_ICMP)
    address = None

    if len(sys.argv) != 2:
        print_usage()
        exit()
    try:
        address:str = sys.argv[1]
    except:
        print_usage()
        exit()

    if len(address)==2:
        ip, prefix_str = address
        prefix:int = int(prefix_str)
    else:
        ip = address[0]
        prefix:int = 32
    host_range:int = prefix2range(prefix)
    if not host_range:
        print_usage()
        exit()

    mask:int = 0xffffffff & ~((1 << (32 - prefix)) - 1)

    raw_ip = int(ipaddress.ip_address(ip))
    network_id = mask & raw_ip
    for host_id in range(host_range):
        ip = socket.inet_ntoa(int.to_bytes(network_id + host_id, 4, "big"))
        send_icmp(sock, ip)

    time.sleep(3)

    for tmp in ping_response:
        tmp:dict
        if ping_response[tmp] == True:
            print(tmp)

main()
quit()
