#include <stdio.h>
#include <string.h>

int main() {
    char *sign = "1";
    char *exp = "10000000";
    unsigned int val = 0;
    if ((*sign) - '0') {
        val = 1<<31;
    }
    val = val + (1<<30);
    //int i;
    /*for (i = 30; i >= 23; i--) {
        if ((*exp) - '0') {
            val = 1<<i;
        }
        exp++;
    }*/
    printf("%u\n", val);
    return 0;
}
