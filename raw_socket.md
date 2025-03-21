NAME 
    raw - Linux IPv4 raw sockets

SYNOPSIS
    #include <sys/socket.h>
    #include <netinet/in.h>
    raw_socket = socket(AF_INET, SOCK_RAW, int protocol);

DESCRIPTION
   Raw sockets allow new IPv4 protocols to be implemented in user space. A raw socket receives or sends the raw datagram not including link level headers.

   The IPv4 layer generates an IP header when sending a packet unless the IP_HDRINCL socket option is enabled on the socket. When it is enabled, the packet must contain an IP header. For receiveing, the IP header is alwasy included in the packet.

   In order to create a raw sockt, a process must have the CAP_NET_RAW capabillity in the user namespace that governs its network namepaces. 
 
   All packets or errors matching the protocol number specified for the raw socket are passed to this socket. For a list of the allowed protocols, see the IANA list of assigned protocol numbers at http://www.iana.org/assignments/protocol-numbers/ and getprotobyname(3).

   A protocol of IPPROTO_RAW implies enabled IP_HDRINCL and is able to send any IP rotocol that is specified in the passed header. Receiving of all IP protocols via IPPROTO_RAW is not possible using raw sockets.


   IP Header fileds modified on sending by IP_HDRINCL
   IP checksum                 Always filled in
   Source Address              Filled in when zero
   Packet ID                   Fiiled in when zero
   Total Length                Always filled in


   If IP_HDRINCL is specified and the IP header has a nonzero destination address, the n the destination address of the socket is used to route the packet. When MSG_DONTROUTE is specified, the destination address should refer to a local interfacle, otherwise a routing table lookup is done anyway but gatewayed routes are ignored.

   If IP_HDRINCL isn't set. then IP header options can be set on raw sockets with setsockets(2); see ip(7) for more information.

   Starting with Linux 2.2, all IP header fileds and options can be set using IP socket options. This means raw sockets are usually needed only for new protocols or protocols with no user interface (like ICMP).

   When a packet is received, it is passed to any raw sockets which have been bound to its protocol before it is passed to other protocol handlers (e.g., kernel protocol modules).

  Address format 
   For sending and receiving datagrams, raw sockets use the standard sockaddr_in address structure defined in ip(7). The sin_port field could be used to specifiy the IP protocol number, but it is ignored for sending in Linux 2.2 and later, and should be always set to 0 (see BUGS). For incmoing packets, sin_port is set to zero.

  Socket options
   Raw socket options can be set with setsockopt(2) and read with getsockopt(2) by passing the IPPROTO_RAW family flag.

  ICMP_FILTER
   Enable a special filter for raw sockets bound to the IPPPROTO_ICMP protocol. The value has a bit set for each ICMP message type which should be filtered out. The default is to filter no ICMP messages.

   In addtion, all ip(7) IPPROTO_IP socket options valid for datagram sockets are support.

  Error handling
   Errors orI
