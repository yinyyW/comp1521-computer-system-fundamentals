# COMP1521 18s1 Assignment 2

CC = gcc
CFLAGS = -Wall -Werror -std=c99 -g
BINS = test1 test2 test3 test4

all : $(BINS)

test1 : test1.o myHeap.o
test2 : test2.o myHeap.o
test3 : test3.o myHeap.o
test4 : test4.o myHeap.o Tree.o
test4.o : test4.c myHeap.h Tree.h

clean :
	rm -f $(BINS) *.o core
