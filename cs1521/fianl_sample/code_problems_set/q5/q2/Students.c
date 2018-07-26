// Students.c ... implementation of Students datatype

#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <assert.h>
#include "Students.h"

typedef struct _stu_rec {
	int   id;
	char  name[20];
	int   degree;
	float wam;
} sturec_t;

typedef struct _students {
    int    nstu;
    StuRec recs;
} students_t;

// read text from input (FILE *)
// write sturec_t structs to output (filedesc)
int makeStuFile(char *inFile, char *outFile)
{
	FILE *in = fopen(inFile, "r");
	if (in == NULL) return -1;
	int out = open(outFile, O_WRONLY | O_CREAT, 0644);
	if (out == -1) return -2;
	char buf[100];
	sturec_t stu;
	while (fgets(buf, 99, in) != NULL) {
	    if (sscanf(buf, "%d %s %d %f", &stu.id, &stu.name[0], &stu.degree, &stu.wam) != 4) {
	        return -3;
	    } else {
	        write(out, &stu, sizeof(sturec_t));
	    }
	}
	close(out);
	fclose(in);
	return  0;
}

// build a collection of student records from a file descriptor
Students getStudents(int in)
{
    int ns;  // count of #students

	// Make a skeleton Students struct
	Students ss;
	if ((ss = malloc(sizeof (struct _students))) == NULL) {
		fprintf(stderr, "Can't allocate Students\n");
		return NULL;
	}

	// count how many student records
    int stu_size = sizeof(struct _stu_rec);
    sturec_t s;
	ns = 0;
    while (read(in, &s, stu_size) == stu_size) ns++;
    ss->nstu = ns;
    if ((ss->recs = malloc(ns*stu_size)) == NULL) {
		fprintf(stderr, "Can't allocate Students\n");
		free(ss);
		return NULL;
	}

	// read in the records
	lseek(in, 0L, SEEK_SET);
	for (int i = 0; i < ns; i++)
		read(in, &(ss->recs[i]), stu_size);

	close(in);
	return ss;
}

// show a list of student records pointed to by ss
void showStudents(Students ss)
{
	assert(ss != NULL);
	for (int i = 0; i < ss->nstu; i++)
		showStuRec(&(ss->recs[i]));
}

// show one student record pointed to by s
void showStuRec(StuRec s)
{
	printf("%7d %s %4d %0.1f\n", s->id, s->name, s->degree, s->wam);
}
