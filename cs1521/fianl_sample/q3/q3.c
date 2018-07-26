#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

// Data definitions

typedef struct _job {
	int id;	   // Job ID
	int size;	 // # KB (also time == size/100)
	int user;	 // owner of job
	int priority; // importance of job
} Job;

typedef struct _queue {
	int njobs;	// # jobs currently on queue
	int maxjobs;  // # elements in jobs array
	Job *jobs;	// array of jobs, dynamically allocated
} JobQ;

// functions on job queues

JobQ *initQ(int);
void addToQ(JobQ *, Job);
Job  removeQhead(JobQ *);
int  isFullQ(JobQ *);
int  isEmptyQ(JobQ *);
void showQstats(JobQ *);

// main function: set up queue, run print jobs

int main(int argc, char **argv)
{
	int  time = 0;	// current time
	int  jobID = 1;   // job ID for next job
	int  ending = 0;  // end time of current job
	char line[100];   // input line
	Job  curr;		// current printing job
	JobQ *printQ;	 // printer queue

	// get queue size from argv[1] and initialize queue
	if (argc < 2) {
		printf("Usage: %s QueueSize < JobsFile\n", argv[0]);
		exit(1);
	}
	int maxQ = atoi(argv[1]);
	if (maxQ < 1) {
		printf("Queue must have at least one entry\n");
		exit(1);
	}
	printQ = initQ(maxQ);
	if (printQ == NULL) {
		printf("Can't create printer queue\n");
		exit(1);
	}

	// run print jobs read from standard input
	for (;;) {
		// get next job (if any) from standard input
		if (fgets(line,99,stdin) != NULL) {
			int n; int size; int user;
			n = sscanf(line, "%d %d", &size, &user);
			if (n < 2) { printf("Bad: %s", line); continue; }
			Job new;
			new.id = jobID++; new.size = size; new.user = user;
			if (isFullQ(printQ)) {
				printf("Printer overload!\n");
				exit(1);
			}
			new.priority = 100-size + 20-user;
			addToQ(printQ, new);
		}
		// once no more jobs, simulation ends
 		if (isEmptyQ(printQ)) break;
		// show current state of queue
		printf("\nt = %d", time);
		if (time > 0)
			printf(", current job %d ends at t=%d", curr.id, ending);
		printf("\n");
		showQstats(printQ);
		// if current job just finished, schedule a new one
		if (time >= ending) {
			curr = removeQhead(printQ);
			int duration = curr.size/10;
			if (duration < 1) duration = 1;
			ending += duration;
			printf("Now starting job %d\n",curr.id);
		}
		time++;
	}
	return 0;
}

// create an empty job queue of size N
JobQ *initQ(int N)
{
	// TODO ... replace this line by your code
}

// add a new job to the queue in priority order
void addToQ(JobQ *q, Job j)
{
	assert(q != NULL);
	// TODO ... replace this line by your code
}

// remove the first job from the queue
Job removeQhead(JobQ * q)
{
	assert(q != NULL);
	// TODO ... replace this line by your code
}

// check whether the queue is full
int  isFullQ(JobQ *q)
{
	assert(q != NULL);
	return (q->njobs == q->maxjobs);
}

// check whether the queue is empty
int  isEmptyQ(JobQ *q)
{
	assert(q != NULL);
	return (q->njobs == 0);
}

// show current state of queue
void showQstats(JobQ *q)
{
	printf("%5s %5s %5s %5s\n", "ID", "Size", "User", "Prio");
	for (int i = 0; i < q->njobs; i++) {
		Job j = q->jobs[i];
		printf("%5d %5d %5d %5d\n", j.id, j.size, j.user, j.priority);
	}
}
