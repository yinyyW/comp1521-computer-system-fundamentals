// stu.c ... manipulate student records

#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include "Students.h"

int main(int argc, char *argv[])
{
	if (argc < 3) {
		fprintf(stderr, "Usage: %s MiNWAM StuFile\n", argv[0]);
		return 1;
	}

	// get min WAM value
	float minWam;
	if (sscanf(argv[1], "%f", &minWam) < 1) {
		fprintf(stderr, "Invalid WAM %s\n", argv[1]);
		return 1;
	}
	
	// attempt to open named file
	int fd;  // input file descriptor
	if ((fd = open(argv[2], O_RDONLY)) < 0) {
		fprintf(stderr, "Can't open %s\n", argv[2]);
		return 1;
	}

	// fetch student records
	Students ss = getStudents(fd);
	if (ss == NULL) {
		fprintf(stderr, "Can't set up student records\n");
		return 1;
	}

	// sort student records
	Students ss2 = filterOnWAM(ss, minWam);

	// display student records
	printf("Original\n");
	showStudents(ss);
	printf("Filtered\n");
	showStudents(ss2);

	return 0;
}
