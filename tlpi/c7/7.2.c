#include <assert.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include "../lib/tlpi_hdr.h"

typedef struct freeL {
  long int len;
  struct freeL* previous;
  struct freeL* next;
} freeL;

freeL* head = NULL;

static const int LEN_SIZE = sizeof(long int);
static const int ENTRY_SIZE_FIXED = LEN_SIZE + 2 * sizeof(void*);

bool can_fit(freeL* entry, long int size) {
  return (entry->len - size) > 0;
}

void pop_from_free_list(freeL* entry) {
  if (entry->previous == NULL) {
    head = entry->next;
  } else {
    entry->previous->next = entry->next;
  }

  if (entry->next != NULL) {
    entry->next->previous = entry->previous;
  }
}

void* c_malloc(long int size) {
  printf("\n\n");
  // assuming sizeof(long int) and sizeof(void*) is the same.
  // this would break on systems where it is different
  assert(sizeof(void*) == sizeof(long int));
  // production malloc is page-addressed, rather than relying on byte
  // addressing
  long int ENTRY_SIZE = size + ENTRY_SIZE_FIXED;
  printf("ENTRY_SIZE: %ld\n", ENTRY_SIZE);

  if (head == NULL) {
    printf("sbrk entry newly allocated:and pb: %10p\n", sbrk(0));

    freeL* entry = sbrk(ENTRY_SIZE);
    printf("sbrk entry newly allocated: %10p and pb: %10p\n", entry, sbrk(0));
    if (entry == NULL) {
      return NULL;
    }
    entry->len = ENTRY_SIZE - LEN_SIZE;
    entry->previous = entry->next = NULL;
    return &(entry->previous);  // skip 'len'
  }

  // best fit strategy
  freeL* best_candidate = NULL;
  long int best_gap = LONG_MAX;
  for (freeL* curr = head; curr != NULL; curr = curr->next) {
    int hole_sz = curr->len - size;
    if (hole_sz < best_gap && hole_sz >= 0) {
      best_gap = hole_sz;
      best_candidate = curr;
    }
  }

  // typically if a slot is much larger than requested size, it's broken up into
  // smaller piece, with the size-reduced entry now remaining on the free list.

  if (best_candidate == NULL) {
    // no slot available big enough to fit `size`. Adjust brk
    freeL* new_slot = sbrk(ENTRY_SIZE);
    printf("sbrk head newly allocated (bc): %10p and pg: %10p\n", new_slot,
           sbrk(0));
    if (new_slot == NULL) {
      return NULL;
    }
    new_slot->len = ENTRY_SIZE - LEN_SIZE;

    return &(new_slot->previous);
  }

  pop_from_free_list(best_candidate);
  printf("best_candidate: %10p\n", best_candidate);

  return &(best_candidate->previous);
}

void c_free(void* ptr) {
  printf("\n\n");
  if (ptr == NULL) {
    return;
  }

  // return slot to the free list
  ptr -= LEN_SIZE;
  freeL* entry_ptr = (freeL*)ptr;
  printf("entry location to free: %10p\n", ptr);
  entry_ptr->previous = NULL;
  entry_ptr->next = head;
  head = entry_ptr;

  // use brk to release memory off heap if continuous memory location is free at
  // top.
  bool found;
  do {
    found = false;
    void* program_break = sbrk(0);

    for (freeL* entry = head; entry != NULL; entry = entry->next) {
      if (program_break == ((void*)entry + LEN_SIZE + entry->len)) {
        // release this from free list
        pop_from_free_list(entry);
        found = true;
        int ENTRY_SIZE = LEN_SIZE + entry->len;
        void* loc = sbrk(-ENTRY_SIZE);
        printf("new location after shrink: %10p and %d\n", sbrk(0), ENTRY_SIZE);
        break;
      }
    }
  } while (found);
}

int main(int argc, char* argv[]) {
  char* ch = (char*)c_malloc(sizeof(char));
  *ch = 'R';
  printf("location: %10p and value of ch: %c\n", ch, *ch);

  int* arr = (int*)c_malloc(sizeof(int) * 5);
  arr[0] = 1;
  arr[1] = 12;
  arr[2] = 45;
  arr[3] = 90;
  arr[4] = 101;

  printf("\n\nlocation: %10p and value of arr[0], arr[4]: %d, %d\n", arr,
         arr[0], arr[4]);

  c_free(arr);

  long int* arr2 = (long int*)c_malloc(sizeof(long int) * 2);
  arr2[0] = 34;
  arr2[1] = 33;
  printf("\n\nlocation: %10p and value of arr2[0], arr2[1]: %ld, %ld\n", arr2,
         arr2[0], arr2[1]);

  c_free(ch);
  c_free(arr2);
}