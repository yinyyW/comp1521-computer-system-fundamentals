#include <stdio.h>

int main(){
   /* FILE *fp, *pp; char line[100];
    fp = fopen("q2.c", "r");
   // assert(fp != NULL);
    pp = popen("wc -l", "w");
   // assert(pp != NULL);
    while (fgets(line, 100, fp) != NULL)
	fputs(line, pp);
    fclose(fp); pclose(pp);*/
    FILE *p = popen("ls -l", "r");
    char line[200], a[20], b[20], c[20], d[20];
    long int tot = 0, size;
    while (fgets(line, 199, p) != NULL) {
	sscanf(line, "%s %s %s %s %ld", a, b, c, d, &size);
	fputs(line, stdout);
	tot += size;
    }
    printf(" Total : %ld\n", tot);
    return 0;
}
