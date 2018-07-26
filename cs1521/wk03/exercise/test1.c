#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>

int main() {
    char buf[50];
    int val = 32;
    memset(buf, '\0', 40);
    int i;
    int j = 0;
    for (i = 31; i >= 0; i--) {
        if (j == 1 || j == 10) {
               buf[j] = ' ';
               j++;
               continue;
           }
           unsigned int re = 1<<i;
           if (re & val) {
               buf[j] = '1';
           } else {
               buf[j] = '0';
           }
           j++;
    }
    printf("%s\n", buf);
    return 0;
}
