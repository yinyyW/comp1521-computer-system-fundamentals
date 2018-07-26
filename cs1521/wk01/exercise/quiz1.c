#include <stdio.h>

int main(){
	int a = 5;
	int *p;
	p = &a;
	*p = *p + 1;
	a++;
	printf("%d\n", a);
	return 0;
}
