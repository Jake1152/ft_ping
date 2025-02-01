#include <sys/socket.h>
#include <netinet/in.h>
#include <errno.h>
#include <unistd.h> 
#include <stdio.h>
#include <string.h>

const int BUF_SIZE = 65536;

int main()
{
    int               packet_size;
    int               raw_sockfd;
    char              *buf;
    struct sockaddr   addr;
    socklen_t         addrlen;
    
    raw_sockfd = socket(AF_INET, SOCK_RAW, IPPROTO_ICMP);

    memset(&addr, 0, sizeof(addr));

    addr.sa_family = AF_UNIX;

    if (raw_sockfd == -1)
    {
        perror("Unable to create raw socket.");
        printf("errno is %d", errno);
        return 1;
    }

    if (bind(raw_sockfd, &addr, sizeof(addr)) == -1)
    {
        perror("Unable to bind raw socket.");
        printf("errno is %d", errno);
        return 1;
    }
    for (;;)
    {
        // 1. sendto 
        
        // 2. recvfrom
        packet_size = recvfrom(raw_sockfd, buf, BUF_SIZE, 0, NULL, NULL);
        if (packet_size == -1)
        {
            perror("Unable to retrieve data from socket");
            return 1;
        }
    }
    return 0;
} 