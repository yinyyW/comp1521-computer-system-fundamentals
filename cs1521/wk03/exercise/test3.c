#include <stdio.h>
#include <string.h>

int main() 
{
    //11000010111011010100000000000000  
    // 1 sign bit | 8 exponent bit | 23 fraction bits
    float val = 2.50;
    char buf[50];
    memset(buf, '\0', 50);
    int i;
    int *f;
    f = &val;
    int j = 0;
    for (i = 31; i >= 0; i--)
    {
        if (j == 1 || j == 10) {
            buf[j] = ' ';
            i++;
            j++;
            continue;
        }
        unsigned int re = 1<<i;
        if (re & *f) {
           buf[j] = '1';
       } else {
           buf[j] = '0';
       }
       j++;
    }
    printf("%s\n", buf);
    return 0;
}
