#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
int main() {
    int fd = open("myls.c", O_RDONLY);
    if (fd < 0) {
	perror(NULL);
	exit(1);
    }
    return 0;
}
