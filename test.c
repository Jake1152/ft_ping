#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>

int main()
{
  int sockfd = socket(AF_INET, SOCK_RAW, IPPROTO_ICMP); 

  const int on = 1;

  if (setsocketopt(sockfd, IPPROTO_IP, IP_HDRINCL, &on, sizeof(on)) < 0)
  {
    printf("setsocketopt error");
    return -1;
  }

  while (recvfrom())
    ; 

  close(fd);

  return 0;
}
