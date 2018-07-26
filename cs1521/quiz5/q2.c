#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

int main() {
    pid_t id;
    //int stat;
    if ((id = fork()) != 0) {
	   printf("I am the parent process,my process id is %d\n", getpid());
	   printf("I am the child process, A = %d\n", id);
	   //wait(&stat);
	   //printf("stat = %d\n", stat);
	   return 1;
    } else {
	   printf("B = %d\n", getppid());
	   return 0;
    }
}
