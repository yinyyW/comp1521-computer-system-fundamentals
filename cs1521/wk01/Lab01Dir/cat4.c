// Copy input to output
// COMP1521 18s1

#include <stdlib.h>
#include <stdio.h>

void copy(FILE *, FILE *);

int main(int argc, char *argv[])
{
	FILE *fp;
	if (argc < 2) {
		copy(stdin, stdout);		
	} else {
		int i;
		for (i = 1; i < argc; i++) {
			fp = fopen(argv[i], "r");
			if (fp == NULL) {
				printf("Can't read NameOfFile");
			}
			copy(fp, stdout);
			fclose(fp);
		}
	}
	return EXIT_SUCCESS;
}

// Copy contents of input to output, char-by-char
// Assumes both files open in appropriate mode

void copy(FILE *input, FILE *output)
{
    char temp[BUFSIZ];
	while (fgets(temp, BUFSIZ, input) != NULL) {
		fputs(temp, output);
	}
}
