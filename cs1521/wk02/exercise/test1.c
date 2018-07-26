#include <stdio.h>
#include <stdlib.h>    
    
int main() {
    char *str1 = "ab;cd";
    char *cur;
    cur = str1;
    while ('0' > *cur || *cur > '9') {
        if (*cur == '\0') {
            printf("invalid");
            break;
        }
        cur++;
    }
 
    printf("\n");
    return 0;
}
