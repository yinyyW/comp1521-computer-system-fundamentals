// where_are_the_bits.c ... determine bit-field order
// COMP1521 Lab 03 Exercise
// Written by ...

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>

typedef uint32_t Word;

struct _bit_fields {
   unsigned int a : 4,
                b : 8,
                c : 20;
};

typedef struct _bit_fields Bit32;

union _bits32 {
   Word val;
   Bit32 bits;
};
typedef union _bits32 Union32;

int main(void)
{
   Union32 new;

   new.bits.a = 0xa;
   new.bits.b = 0xbb;
   new.bits.c = 0xccccc;
   
   printf("%x\n", new.val);
    char buf[50];
    memset(buf, '\0', 40);
    int i;
    int j = 0;
    for (i = 31; i >= 0; i--) {
       unsigned int re = 1<<i;
       if (re & new.val) {
          buf[j] = '1';
       } else {
          buf[j] = '0';
       }
      j++;
   }

    printf("%u\n",sizeof(new));
    printf("%s\n", buf);

   return 0;
}
