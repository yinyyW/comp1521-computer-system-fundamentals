#include <stdio.h>
#include <string.h>
#include <math.h>

#include <inttypes.h>

typedef uint32_t Word;




int main() {
    

    Word xval = 0;
    char *sign = "1";
    char *exp = "10000000";
    char *frac = "01000000000000000000000";
   // this line is just to keep gcc happy
   // delete it when you have implemented the function
  if ((*sign) - '0') {
       xval = 1<<31;
   }

   int i;
   for (i = 30; i >= 23; i--) {
       if ((*exp) - '0') {
           xval = 1<<i;
       }
       exp++;
   }
   // convert char *exp into an 8-bit value in new.bits
   int j;
   for (j = 22; j >= 0; j--) {
       if ((*frac) - '0') {
           xval = 1<<j;
        }
       frac++;
   }

    //float val = 2.5;
    /*char buf[50];
    memset(buf, '\0', 50);
    int k;
    //int *f;
    //f = &val;
    int m = 0;
    for (k = 31; k >= 0; k--)
    {
        if (m == 1 || m == 10) {
            buf[m] = ' ';
            k++;
            m++;
            continue;
        }
        unsigned int re = 1<<k;
        if (re & xval) {
           buf[m] = '1';
       } else {
           buf[m] = '0';
       }
       m++;
    }
    printf("%s\n", buf);*/
    return 0;
}
