ft_ping : ft_ping.o
	gcc -o ft_ping ft_ping.o

ft_ping.o : ft_ping.c
	gcc -c -o ft_ping.o ft_ping.c

clean :
	rm *.o ft_ping