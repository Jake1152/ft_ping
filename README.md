#  ft_ping


## Introduction
Ping is the name of a command that allows to test the accessibility of another machine though the IP network. The command measures also the time taken to receive a reponse, called round-trip time


## General Instructions
- Your project must be realized in virtual machine running on Debian(>= 7.0)
- Your virtual machine must have all the necessary software to complete your progject. These softwares must be configured and installed.
- You must be able to use your virtual machine from a cluster computer.
- This project will be corrected by humans only. You're allowed to organise and name your files as you see fit, but you must follw the following rules
- You must use C amd submit Makefile
- Your Makefile must compies the project and must contain the usual rules. It must recopile and re-link the program only if necessary.
- You have to handle errors carefully. In no way can your program quit in an unexpected manner (Segmentation falut, bus error, double free, etc).
- You are authorised to use the libc functions to complete this project.

```Markdown
ATTENTION: Usage of exeve, ping, fnctl, poll and ppoll is strictly forbidden.
```


## Mandatory Part 
- The executable must be named ft_ping.
- You will take as reference the ping implementation from inetutiles-2.0 (ping -V).
- You have to manages the -v-? options.

```Markdown
The -v option here well also allow us to see the results in case of a problem or an error linked to the packtes. which logically shouldn't force the program to stop (the modification of the TTL value cand help to force an error). 
```

- You will have to manage a simple IPv4 (address/hostname) as parameters.
- You will have to manage FQND without doing the DNS resolution in the packet return 

```Markdown
You are allowed to use all functions of the printf family.
```


```Markdown
For the smarty pants (or not)... Obviously you are NOT allowed to acll a real ping.
```

## Bonus Part
Find below a few ideas of interesting bonues:
- Additional -f -l -n -w -W -p -r -s -T --ttl --ip-timestamp flags...


```Markdown
the flags -V, -usage, -echo are not considered as bonus
```


```Markdown
Of course two flags corresponding to the same feature (eg: -t and -type) are not considered as two bonuses
```


```Markdown
The bonus part will only be assessed if the mandatory part is
PERFECT. Perfect means the mandatory part has been integrally done
and works without malfunctioning. If you have not passed ALL the
mandatory requirements, your bonus part will not be evaluated at all.
```
