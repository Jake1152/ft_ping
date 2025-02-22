NAME = ft_ping
CC = gcc
CFLAGS = -Wall -Wextra -Werror
SRCS = ft_ping.c
OBJS = $(SRCS:.c=.o)
RM = rm -f

%.o : %.c
	$(CC) $(CFLAGS) -c $^ -o $@

$(NAME) : $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

all : $(NAME)

clean :
	$(RM) $(OBJS)

fclean: clean
	$(RM) $(NAME)

re :
	make fclean
	make all

.PHONY: all clean fclean re

# target: dependency
# (tab)command
# $@: 현재 타겟의 이름
# $^: 현재 타켓의 종속 항목 리스트

