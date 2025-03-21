import socket
import struct
import time

def checksum(data):
    sum = 0
    for i in range(0, len(data), 2):
        part = (data[i] << 8) + (data[1] if i+1 < len(data) else 0)
        sum += part
        sum = (sum & 0xffff) + (sum >> 16)
    return ~sum & 0xffff

def create_icmp_packet(seq):
    icmp_type = 8
    code = 0
    identifier = 1234
    seq_number = seq
    payload = b'HelloICMP'

    # Create ICMP header: Type (1 byte), Code (1 byte), Checksum (2 bytes), Identifier (2 bytes), Sequence (2 bytes)
    header = struct.pack("!BBHHH", icmp_type, code, 0, identifier, seq_number)
    checksum_value = checksum(header + payload)
    header = struct.pack("!BBHHH", icmp_type, code, checksum_value, identifier, seq_number)

    return header + payload

def send_icmp_request(target_ip):
    sock = socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_ICMP)
    sock.settimeout(2)

    packet = create_icmp_packet(1)
    sock.sendto(packet, (target_ip, 0))

    print(f"Sent ICMP echo Request to {target_ip}")
    sock.close()

send_icmp_request("8.8.8.8")