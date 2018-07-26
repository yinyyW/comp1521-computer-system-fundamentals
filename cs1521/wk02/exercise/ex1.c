#include <stdio.h>

int main() {
    char *str = "123";
    char s[10];
    s[0] = *str;
    printf("%c\n", s[0]);
    char *cur;
    cur = str;
    cur++;
    s[1] = *cur;
    printf("%c\n", s[1]);
    return 0;
}
