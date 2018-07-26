#include <stdio.h>

int main() {
    //initialize
    char *ch = "1234";
    char *start;
    start = ch;
    char *cur;
    cur = ch;
    while (*(cur + 1) != '\0') {
        cur++;
    }
    char *end;
    end = cur;
    putchar(*end);
    putchar(*start);
    printf("%p\n", end);
    printf("%p\n", start);
    printf("%d\n", end - start);

    
    return 0;
}
