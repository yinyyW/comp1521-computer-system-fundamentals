# Makefile for COMP1521 Practice Prac Exam

CC=gcc
CFLAGS=-std=c99 -Wall -Werror

all : stu mkstu

stu : stu.o Students.o
mkstu : mkstu.o Students.o

stu.o : stu.c Students.h
mkstu.o : mkstu.c Students.h
Students.o : Students.c Students.h

clean :
	rm -f stu mkstu stu.o mkstu.o Students.o
