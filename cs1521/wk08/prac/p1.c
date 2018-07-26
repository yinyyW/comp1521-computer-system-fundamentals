#include <stdio.h>

int main(void) {
    printf("Hello\n");
    if (fork() != 0)
	printf("Gan\n");
    else
	printf("Prost\n");
    printf("Goodbye\n");
}
