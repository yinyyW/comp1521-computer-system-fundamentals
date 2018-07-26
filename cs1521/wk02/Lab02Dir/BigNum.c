// BigNum.h ... LARGE positive integer values

#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <ctype.h>
#include "BigNum.h"

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
void addBigNums(BigNum n, BigNum m, BigNum *res)
{
    int max = 0;

    if (n.nbytes > m.nbytes) {
        max = n.nbytes;
    } else {
        max = m.nbytes;
    }
    if (max > res->nbytes) {
        res->nbytes = max + 1;
        res->bytes = realloc(res->bytes, sizeof(Byte) * res->nbytes);
        res->bytes[max] = '0';
        if (max == n.nbytes) {
            m.bytes = realloc(m.bytes, sizeof(Byte) * (max + 1));
            n.bytes = realloc(n.bytes, sizeof(Byte) * (max + 1));
            n.bytes[max] = '0';
            int j;
            for (j = m.nbytes; j <= max; j++) {
                m.bytes[j] = '0';
            }
        } else {
            n.bytes = realloc(n.bytes, sizeof(Byte) * (max + 1));
            m.bytes = realloc(m.bytes, sizeof(Byte) * (max + 1));
            m.bytes[max] = '0';
            int k;
            for (k = n.nbytes; k <= max; k++) {
                n.bytes[k] = '0';
            }
        }
    }
    int ca = 0;
    int i;
    int num1, num2, sum;
    for (i = 0; i < res->nbytes; i++) {
        num1 = m.bytes[i] - '0';
        num2 = n.bytes[i] - '0';
	    sum = num1 + num2 + ca;
        ca = (sum >= 10) ? 1 : 0;
        sum = sum % 10;
        res->bytes[i] = '0' + sum;
    }
    return;
}

// Set the value of a BigNum from a string of digits
// Returns 1 if it *was* a string of digits, 0 otherwise
int scanBigNum(char *s, BigNum *n)
{
    //find start of the digits
    char *cur;
    cur = s;
    while ('0' > *cur || *cur > '9') {
        if (*cur == '\0') {
            return 0;
        }
        cur++;
    }

    char *end, *start;
    end = cur;
    //scan to last digit
    while ('0' <= *(cur + 1) && *(cur + 1) <= '9' && *(cur + 1) != '\0') {
        cur++;
    }
    //place these sequence into BigNum
    int i = 0;
    start = cur;
    if ((start - end + 1) > n->nbytes) {
        n->nbytes = start - end + 1;
        n->bytes = realloc(n->bytes, sizeof(Byte) * (start - end + 1));
    }
    while (start != end) {
        n->bytes[i] = *start;
        start--;
        i++;
    }
    n->bytes[i++] = *end;
    return 1;
}

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
    for (j = i; j >= 0; j--) {
        putchar(n.bytes[j]);
    }
    return;
}

