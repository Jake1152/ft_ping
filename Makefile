NAME = ft_ping

$(NAME) : ft_ping.o
	gcc -o ft_ping ft_ping.o

ft_ping.o : ft_ping.c
	gcc -c -o ft_ping.o ft_ping.c

all : 
	gcc -o $(NAME) 

clean :
	rm *.o ft_ping

re :
	make clean
	make all

#target: dependency
#(tab)command

