// COMP1521 18s1 Week 07 Lab
// Virtual Memory Simulation

#include <stdlib.h>
#include <stdio.h>

typedef unsigned int uint;

// Page Table Entries

#define NotLoaded 0
#define Loaded    1
#define Modified  2

#define PAGESIZE  4096
#define PAGEBITS  12

#define actionName(A) (((A) == 'R') ? "read from" : "write to")

typedef struct {
   int status;        // Loaded or Modified or NotLoaded
   int frameNo;       // -1 if page not loaded
   int lastAccessed;  // -1 if never accessed
} PTE;

// Globals

uint nPages;         // how many process pages
uint nFrames;        // how many memory frames

PTE *PageTable;      // process page table
int *MemFrames;      // memory (each frame holds page #, or -1 if empty)

uint nLoads = 0;     // how many page loads
uint nSaves = 0;     // how many page writes (after modification)
uint nReplaces = 0;  // how many Page replacements

uint clock = 0;      // clock ticks

// Functions

void initPageTable();
void initMemFrames();
void showState();
int  physicalAddress(uint vAddr, char action);

// main:
// read memory references
// maintain VM data structures
// argv[1] = nPages, argv[2] = nFrames
// stdin contains lines of form
//   lw  $t0, Address
//   sw  $t0, Address
// Address is mapped to a page reference
// as per examples in lectures
// Note: pAddr is signed, because -ve used for errors

int main (int argc, char **argv)
{
   char line[100]; // line buffer
   char action;    // read or write
   uint vAddr;     // virtual address (unsigned)
   int  pAddr;     // physical address (signed)

   if (argc < 3) {
      fprintf(stderr, "Usage: %s #pages #frames < refFile\n", argv[0]);
      exit(1);
   }

   nPages = atoi(argv[1]);
   nFrames = atoi(argv[2]);
   // Value 2 also picks up invalid argv[x]
   if (nPages < 1 || nFrames < 1) {
      fprintf(stderr, "Invalid page or frame count\n");
      exit(1);
   }

   initPageTable(); initMemFrames();

   // read from standard input
   while (fgets(line,100,stdin) != NULL) {
      // get next line; check valid (barely)
      if ((sscanf(line, "%c %d\n", &action, &vAddr) != 2)
                     || !(action == 'R' || action == 'W')) {
         printf("Ignoring invalid instruction %s\n", line);
         continue;
      }
      // do address mapping
      pAddr = physicalAddress(vAddr, action);
      if (pAddr < 0) {
         printf("\nInvalid address %d\n", vAddr);
         exit(1);
      }
      // debugging ...
      printf("\n@ t=%d, %s pA=%d (vA=%d)\n",
             clock, actionName(action), pAddr, vAddr);
      // tick clock and show state
      showState();
      clock++;
   }
   printf("\n#loads = %d, #saves = %d, #replacements = %d\n", nLoads, nSaves, nReplaces);
   return 0;
}

// map virtual address to physical address
// handles regular references, page faults and invalid addresses

int physicalAddress(uint vAddr, char action)
{
   // TODO: write this function
   int pageno = vAddr/PAGESIZE;
   int offset = vAddr%PAGESIZE;
   int physicalAddr;
   int frameno;
   if (pageno >= nPages || pageno < 0) {
       return -1;
   }
   if (PageTable[pageno].status == Loaded || PageTable[pageno].status == Modified) {
       if (action == 'W') {
           PageTable[pageno].status = Modified;
       }
       frameno = PageTable[pageno].frameNo;
       PageTable[pageno].lastAccessed = clock;
       physicalAddr = frameno * PAGESIZE + offset;
   } else {
       int i;
       for(i = 0; i < nFrames; i++) {
           if (MemFrames[i] == -1) {
               MemFrames[i] = pageno;
               if (action == 'W') {
                   PageTable[pageno].status = Modified;
               } else {
                   PageTable[pageno].status = Loaded;
               }
               PageTable[pageno].lastAccessed = clock;
               PageTable[pageno].frameNo = i;
               frameno = i;
               physicalAddr = frameno * PAGESIZE + offset;
               nLoads++;
               return physicalAddr;
           }
       }
       nLoads++;
       nReplaces++;
       int j;
       unsigned int least=0xffffffff;

       int find = 0;
       for(j = 0; j < nPages; j++) {
           if (PageTable[j].lastAccessed < least && PageTable[j].lastAccessed >= 0) {
               least = PageTable[j].lastAccessed;
               find = j;
           }
       }
       if (PageTable[find].status == Modified) {
           nSaves++;
       }
       frameno = PageTable[find].frameNo;
       PageTable[find].status = NotLoaded;
       PageTable[find].lastAccessed = -1;
       PageTable[find].frameNo = -1;
       if (action == 'W') {
           PageTable[pageno].status = Modified;
       } else {
           PageTable[pageno].status = Loaded;
       }
       PageTable[pageno].lastAccessed = clock;
       PageTable[pageno].frameNo = frameno;
       MemFrames[frameno] = pageno;
       physicalAddr = frameno * PAGESIZE + offset;
   }
   return physicalAddr; // replace this line
}

// allocate and initialise Page Table

void initPageTable()
{
   PageTable = malloc(nPages * sizeof(PTE));
   if (PageTable == NULL) {
      fprintf(stderr, "Insufficient memory for Page Table\n");
      exit(1);
   }
   for (int i = 0; i < nPages; i++) {
      PageTable[i].status = NotLoaded;
      PageTable[i].frameNo = -1;
      PageTable[i].lastAccessed = -1;
   }
}

// allocate and initialise Memory Frames

void initMemFrames()
{
   MemFrames = malloc(nFrames * sizeof(int));
   if (MemFrames == NULL) {
      fprintf(stderr, "Insufficient memory for Memory Frames\n");
      exit(1);
   }
   for (int i = 0; i < nFrames; i++) {
      MemFrames[i] = -1;
   }
}

// dump contents of PageTable and MemFrames

void showState()
{
   printf("\nPageTable (Stat,Acc,Frame)\n");
   for (int pno = 0; pno < nPages; pno++) {
      uint s; char stat;
      s = PageTable[pno].status;
      if (s == NotLoaded)
         stat = '-';
      else if (s & Modified)
         stat = 'M';
      else
         stat = 'L';
      int f = PageTable[pno].frameNo;
      printf("[%2d] %2c, %2d, %2d",
             pno, stat, PageTable[pno].lastAccessed, PageTable[pno].frameNo);
      if (f >= 0) printf(" @ %d", f*PAGESIZE);
      printf("\n");
   }
   printf("MemFrames\n");
   for (int fno = 0; fno < nFrames; fno++) {
      printf("[%2d] %2d @ %d\n", fno, MemFrames[fno], fno*PAGESIZE);
   }
}
