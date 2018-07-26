// Students.c ... implementation of Students datatype

#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include "Students.h"

typedef struct _stu_rec {
	int   id;
	char  name[20];
	int   degree;
	float wam;
} sturec_t;

typedef struct _students {
	int	nstu;
	StuRec recs;
} students_t;

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
	if (ss == NULL)
		printf("NULL\n");
	else if (ss->nstu == 0)
		printf("<no students>\n");
	else {
		for (int i = 0; i < ss->nstu; i++)
			showStuRec(&(ss->recs[i]));
	}
}

// show one student record pointed to by s
void showStuRec(StuRec s)
{
	printf("%7d %s %4d %0.1f\n", s->id, s->name, s->degree, s->wam);
}

// return new Students object based on removing all
//   students with WAM < minWAM from original list
Students filterOnWAM(Students ss, float minWAM)
{
	Students new = malloc(sizeof(students_t));
	int ns = 0;
	int i;
	for(i=0; i < ss->nstu; i++) {
	    if (ss->recs[i].wam >= minWAM) {
	        ns++;
	    }
	}
	new->recs = malloc(sizeof(sturec_t) * ns);
	new->nstu = ns;
	ns = 0;
	for (i=0; i < ss->nstu; i++) {
	    if (ss->recs[i].wam >= minWAM) {
	        new->recs[ns].id = ss->recs[i].id;
            new->recs[ns].degree = ss->recs[i].degree;
            new->recs[ns].wam = ss->recs[i].wam;
            strcpy(new->recs[ns].name, ss->recs[i].name);
            ns++;
        }
    }
    return new;
}
