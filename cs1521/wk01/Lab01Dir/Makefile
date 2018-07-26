# COMP1521 18s1 Week01 Lab

CC=dcc
CFLAGS=-Wall -Werror -std=c99
BINS=cat1 cat2 cat3 cat4
OBJS=cat1.o cat2.o cat3.o cat4.o

all: $(BINS)

cat1 : cat1.o
cat2 : cat2.o
cat3 : cat3.o
cat4 : cat4.o

clean:
	rm -f $(BINS) $(OBJS) core
