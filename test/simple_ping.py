from socket import *
import os

def get_my_ip():
    """현재 사용 중인 네트워크 인터페이스의 IP 주소를 가져오는 함수"""
    s = socket(AF_INET, SOCK_DGRAM)
    try:
        s.connect(("8.8.8.8", 80))  # 외부 서버(구글 DNS)와 연결하여 로컬 IP 확인
        ip = s.getsockname()[0]
    except Exception:
        ip = "127.0.0.1"  # 예외 발생 시 기본값으로 루프백 주소 사용
    finally:
        s.close()
    return ip

def parsing():
    """Raw 소켓을 생성하여 패킷을 수신하는 함수"""
    host = get_my_ip()
    print(f"Listening on {host}")

    if os.name == "nt":
        sock_protocol = IPPROTO_IP
    else:
        sock_protocol = IPPROTO_ICMP

    sock = socket(AF_INET, SOCK_RAW, sock_protocol)
    sock.bind((host, 0))  # 현재 네트워크의 IP 주소로 바인딩
    sock.setsockopt(IPPROTO_IP, IP_HDRINCL, 1)

    try:
        while True:
            data = sock.recvfrom(65535)
            print(data[0])
            print()
    except KeyboardInterrupt:
        print("\nStopped.")
    finally:
        sock.close()

if __name__ == "__main__":
    parsing()
