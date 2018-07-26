// BigNum.h ... LARGE positive integer values

typedef unsigned char Byte;

typedef struct _big_num {
   int  nbytes;  // size of array
   Byte *bytes;  /// array of Bytes
} BigNum;

// Initialise a BigNum to N bytes, all zero
void initBigNum(BigNum *n, int Nbytes);

// Add two BigNums and store result in a third BigNum
void addBigNums(BigNum n, BigNum m, BigNum *res);

// Set the value of a BigNum from a string of digits
// Returns 1 if it *was* a string of digits, 0 otherwise
int scanBigNum(char *s, BigNum *n);

// Display a BigNum in decimal format
void showBigNum(BigNum n);

