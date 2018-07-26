#include <stdio.h>

typedef struct _record {
    int id;
    char givens[20];
    char family[20];
    int uoc_code;
    float WAM;
    char major[6];
    char status;
    char gender;
} Record;

union _multi_faceted {
    int interger;
    char character;
    char string[6];
    float floating_point;
    double double_precision;
} xyz;

union _all {
    int ival;
    char cval;
    char sval[4];
    float fval;
    unsigned int uval;
};

typedef struct _node {
    int value;
    struct _node *next;
} Node;

int main() {
    printf("record size = %d\n", sizeof(Record));
    printf("union size = %d\n", sizeof(xyz));
    printf("node size = %d\n", sizeof(Node));
    union _all var;
    var.uval = 0x00313233;
    printf("%x\n", var.uval);
    printf("%d\n", var.ival);
    printf("%c\n", var.cval);
    printf("%s\n", var.sval);
    printf("%f\n", var.fval);
    printf("%e\n", var.fval);
    printf("\n");
    int m = 0x30 >> 4;
    int n = 0x0f << 0x0f;
    printf("%x\n", m);
    printf("%x\n", n);
    return 0;
}
