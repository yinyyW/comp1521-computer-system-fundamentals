// mkstu.c ... make a file of student records

#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include "Students.h"

int main(int argc, char *argv[])
{
	if (argc < 3) {
		fprintf(stderr, "Usage: %s InFile OutFile\n", argv[0]);
		return 1;
	}

	// read text from input file
	// write student records to output file

	int status = makeStuFile(argv[1], argv[2]);

	switch (status) {
	case -1:
		printf("Can't read %s\n", argv[1]);
		return 1;
	case -2:
		printf("Can't make %s\n", argv[2]);
		return 1;
	case -3:
		printf("Invalid %s\n", argv[1]);
		return 1;
	default:
		return 0;
	}

}
