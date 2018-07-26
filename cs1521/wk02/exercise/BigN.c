// BigNum.h ... LARGE positive integer values

#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <ctype.h>
#include "BigN.h"

// Initialise a BigNum to N bytes, all zero
void initBigNum(BigNum *n, int Nbytes)
{
    n->nbytes = Nbytes;
    n->bytes = malloc(sizeof(Byte) * Nbytes);
    assert(n->bytes != NULL);

    int i;
    for (i = 0; i < Nbytes; i++) {
	    n->bytes[i] = '0';
    }
    return;
}

// Add two BigNums and store result in a third BigNum
/*void addBigNums(BigNum n, BigNum m, BigNum *res)
{
    int rest;
    return;
}

// Set the value of a BigNum from a string of digits
// Returns 1 if it *was* a string of digits, 0 otherwise
int scanBigNum(char *s, BigNum *n)
{
    //find start of the digits
    char *cur;
    cur = s;
    while (('0' > *cur || *cur > '9') && *cur != '\0') {
        cur++;
    }
    if (*cur == '\0') {
        return;
    }
    //scan to last digit
    while ('0' <= *cur && *cur <= '9') {
        cur++;
    }
    //place these sequence into BigNum
    int i = 0;
    char *start;
    for (start = cur; '0' <= *start && *start <= '9'; start--) {
	    n->bytes[i] = *start;
	    i++;
    }
    return 1;
}*/

// Display a BigNum in decimal format
void showBigNum(BigNum n)
{
    int i = (n.nbytes) - 1;
    while (n.bytes[i] == '0' && i >= 0) {
        i--;
    }
    if (i == -1) {
        putchar('0');
        return;
    }

    int j;
    for (j = i; j>=0; j--) {
        putchar(n.bytes[j]);
    }
    return;
}
