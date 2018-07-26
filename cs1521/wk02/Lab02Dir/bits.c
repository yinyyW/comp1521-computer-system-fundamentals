// COMP1521 18s1 Week 02 Lab (warm-up)

#include <stdio.h>

int main()
{
	int len = sizeof(int) * 8;
	int i;
	int temp = 0;
    int ret;
	for (i = 0; i < len - 1; i++) {
        ret = 1<<i;
        temp = temp|ret;
    }
	int x = temp;
	printf("int %x, %d\n", x, x);

	int len2 = sizeof(unsigned int) * 8;
	int i2;
	int temp2 = 0;
    int ret2;
	for (i2 = 0; i2 < len2; i2++) {
        ret2 = 1<<i2;
        temp2 = temp2|ret2;
    }

	unsigned int y = temp2;
	printf("unsigned int %x, %u\n", y, y);

	
	int len3 = sizeof(long int) * 8;
	int i3;
	int temp3 = 0;
    int ret3;
	for (i3 = 0; i3 < len3 - 1; i3++) {
        ret3 = 1<<i3;
        temp3 = temp3|ret3;
    }

	
	long int xx = temp3;
	printf("long int %lx, %ld\n", xx, xx);

	// Code to generate and display the largest "unsigned long int" value

    int len4 = sizeof(unsigned long int) * 8;
	int i4;
	int temp4 = 0;
    int ret4;
	for (i4 = 0; i4 < len4; i4++) {
        ret4 = 1<<i4;
        temp4 = temp4|ret4;
    }
	unsigned long int xy = temp4;
	printf("unsigned long int %lx, %lu\n", xy, xy);

	// Code to generate and display the largest "long long int" value

    int len5 = sizeof(long long int) * 8;
    len5--;
	int i5;
	int temp5 = 0;
    int ret5;
	for (i5 = 0; i5 < len5 - 1; i5++) {
        ret5 = 1<<i5;
        temp5 = temp5|ret5;
    }
	long long int xxx = temp5;
	printf("long long int %llx, %llu?\n", xxx, xxx);

	// Code to generate and display the largest "unsigned long long int" value

    int len6 = sizeof(unsigned long long int) * 8;
	int i6;
	int temp6 = 0;
    int ret6;
	for (i6 = 0; i6 < len6; i6++) {
        ret6 = 1<<i6;
        temp6 = temp6|ret6;
    }
	unsigned long long int xxy = temp6;
	printf("unsigned long long int %llx, %llu\n", xxy, xxy);

	return 0;
}

