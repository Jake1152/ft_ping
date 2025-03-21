// main.c
#include "ping.h"

struct proto proto_v4 = { proc_v4, send_v4, NULL, NULL, 0, IPPROTO_ICMP };

#ifdef  IPV6
struct  proto proto_v6 = { proc_v6, send_v6, NULL, NULL, 0, IPPROTO_ICMPV6 };
#endif

int datalen = 56;

int main(int argc, char **argv)
{
    int c;
    struct addrinfo *ai;
    char            *h;

    opterr = 0;
    while ( (c = getopt(argc, argv, "v")) != -1) {
        switch (c) {
        case 'v':
            verbose++;
            break ;
        case '?':
            err_quit("unrecognized option: %c", c);
        }
    }

    if (optint != argc - 1)
        err_quit("usage: ping [ -v ] <hostname>");

    host = argv[optind];

    pid = getpid() & 0xffff;    // ICMP ID field is 16 bits
    Signal (SIGLRM, sig_alrm);

    ai = Host

    return 0;
}
