// COMP1521 18s1 Assignment 2
// Implementation of heap management system

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "myHeap.h"

// minimum total space for heap
#define MIN_HEAP  4096
// minimum amount of space for a free Chunk (excludes Header)
#define MIN_CHUNK 32

#define ALLOC     0x55555555
#define FREE      0xAAAAAAAA

typedef unsigned int uint;   // counters, bit-strings, ...

typedef void *Addr;          // addresses

typedef struct {             // headers for Chunks
   uint  status;             // status (ALLOC or FREE)
   uint  size;               // #bytes, including header
} Header;

static Addr  heapMem;        // space allocated for Heap
static int   heapSize;       // number of bytes in heapMem
static Addr *freeList;       // array of pointers to free chunks
static int   freeElems;      // number of elements in freeList[]
static int   nFree;          // number of free chunks

static int heapsize(int num) {
   int size = 0;
   if (num <= MIN_HEAP) {
      size = MIN_HEAP;
   } else {
      int j;
      for (j = 0; j < 4; j++) {
         num = num + j;
         if (num % 4 == 0) {
            size = num;
            break;
         }
      }
   }
   return size;
}

static void replaceF(Addr find, Addr replace);
static void deleteF(Addr find);
static void joinF(Addr free);
static Addr getPrevF(Addr find);

// initialise heap
int initHeap(int size)
{
   // TODO
   //init heap
   heapSize = heapsize(size);
   heapMem = malloc(heapSize); 
   if (heapMem == NULL) {
      return -1;
   }

   Header *heapHead = (Header *)heapMem;
   heapHead->status = FREE;
   heapHead->size = heapSize;
   freeElems = heapSize/MIN_CHUNK; 
   freeList = malloc(freeElems * sizeof(Addr));
   if (freeList == NULL)
	   return -1;
   nFree = 1;
   freeList[0] = heapMem;
   return 0; // this just keeps the compiler quiet
}

// clean heap
void freeHeap()
{
   free(heapMem);
   free(freeList);
}

// allocate a chunk of memory
void *myMalloc(int size)
{
   // TODO
   if (size < 1) {
      return NULL;
   }
   Addr curr = heapMem;
   Header *chunk;
   int i;
   //make the size to be the multiple of 4
   for(i = 0; i < 4; i++) {
      size = size + i;
      if (size % 4 == 0){
         break;
      }
   }
   int mallocsize = size + sizeof(Header);
   Addr endHeap = (Addr)((char *)heapMem + heapSize);
   Addr find = NULL;
   //find the smallest free chunk that is larger than size
   unsigned int findsize = 0xffffffff;
   while (curr != endHeap) {
      chunk = (Header *)curr;
      if (chunk->status == FREE && 
          chunk->size >= mallocsize &&
	       chunk->size < findsize) {
         find = curr;
	      //find = (Addr)((char *)curr + sizeof(Header));
	      findsize = chunk->size;
      }
      curr = (Addr)((char *)curr + chunk->size);
   }
   //if not found return null
   if (find == NULL) {
      return NULL;
   }
   Header *findchunk = (Header *)find;
   findchunk->status = ALLOC;
   //if findchunk > S, split it into two chunks
   if (findchunk->size >= MIN_CHUNK + mallocsize) {
      int prevsize = findchunk->size;
      findchunk->size = mallocsize;
      //split findchunk
      Addr next = (Addr)((char *)find + mallocsize);
      Header *nextchunk = (Header *)next;
      nextchunk->status = FREE;
      nextchunk->size = prevsize - mallocsize;
      //delete previous free chunk and insert a new one
      replaceF(find, next);
   }else {
      //if findchunk < S, alloc whole chunk and delete free chunk in freeList
      nFree--;
      deleteF(find);
   }
   return (Addr)((char *)find + sizeof(Header)); // this just keeps the compiler quiet
}

// free a chunk of memory
void myFree(void *block)
{
   // TODO
   //get address of free
   Addr toFree = (Addr)((char *)block - sizeof(Header));
   //printf("%p\n", block);
   if (block == NULL){
      fprintf(stderr, "Attempt to free unallocated chunk\n");
      exit(1);
   }
   //increament nFree and insert it into freeList
   nFree++;
   //insert free chunk to list and return previous free chunk address
   joinF(toFree);

   //change status of alloc chunk to free
   Header *free = (Header *)toFree;

   if (free->status != ALLOC) {
      fprintf(stderr, "Attempt to free unallocated chunk\n");
      exit(1);
   }
   free->status = FREE;

   //check next chunk's status
   Addr next = (Addr)((char *)toFree + free->size);
   Header *nextchunk = (Header *)next;
   //if next is free merge them together and delete 
   if (nextchunk->status == FREE) {
      free->size = free->size + nextchunk->size;
      nFree--;
      deleteF(next);
   }
   //check previous free chunk
   Addr prev = getPrevF(toFree);
   if (prev != 0) {
      Header *prevF = (Header *)prev;
      Addr prevFnext = (Addr)((char *)prev + prevF->size);
      if (prevFnext == toFree) {
         prevF->size = free->size + prevF->size;
         nFree--;
         deleteF(toFree);
      }
   }
}

// convert pointer to offset in heapMem
int  heapOffset(void *p)
{
   Addr heapTop = (Addr)((char *)heapMem + heapSize);
   if (p == NULL || p < heapMem || p >= heapTop)
      return -1;
   else
      return p - heapMem;
}

// dump contents of heap (for testing/debugging)
void dumpHeap()
{
   Addr    curr;
   Header *chunk;
   Addr    endHeap = (Addr)((char *)heapMem + heapSize);
   int     onRow = 0;

   curr = heapMem;
   while (curr < endHeap) {
      char stat;
      chunk = (Header *)curr;
      switch (chunk->status) {
      case FREE:  stat = 'F'; break;
      case ALLOC: stat = 'A'; break;
      default:    fprintf(stderr,"Corrupted heap %08x\n",chunk->status); exit(1); break;
      }
      printf("+%05d (%c,%5d) ", heapOffset(curr), stat, chunk->size);
      onRow++;
      if (onRow%5 == 0) printf("\n");
      curr = (Addr)((char *)curr + chunk->size);
   }
   if (onRow > 0) printf("\n");
}

static void replaceF(Addr find, Addr replace){
    int i = 0;
    while (i < nFree) {
	if (freeList[i] == find) {
	    freeList[i] = replace;
	    break;
	}
	i++;
    }
    return;
}

static void deleteF(Addr find) {
    int i = 0;
    //get the ele before find
    while (freeList[i] != find) {
	i++;
    }
    //delete ele
    while (i < nFree) {
	freeList[i] = freeList[i+1];
	i++;
    }
    freeList[i] = 0;
}

static void joinF(Addr free) {
    int i = 0;
    //find the appropriate position
    while (freeList[i] < free && i < nFree) {
	i++;
    }
    int position = i;
    //adjust other positions' value
    int j;
    for (j = nFree - 1; j > position; j--) {
	freeList[j] = freeList[j - 1];
    }
    freeList[position] = free;
    return;
}

static Addr getPrevF(Addr find) {
    int i;
    for (i = 0; i < nFree; i++) {
       if (freeList[i] == find) {
          break;
       }
    }
    return (i != 0) ? freeList[i-1] : 0;
}
