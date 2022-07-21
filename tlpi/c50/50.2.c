#include <stdio.h>
#include <sys/mman.h>
#include <sys/resource.h>
#include <sys/time.h>
#include "../lib/error_functions.h"

int main(int argc, char* argv[]) {
  printf("creating a private mapping...");
  char* addr =
      mmap(NULL, 3, PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
  if (addr == MAP_FAILED) {
    errExit("mmap failed");
  }

  printf("3 bytes from address: (%c, %c, %c)\n", addr[0], addr[1], addr[2]);
  addr[0] = 'a';
  addr[1] = 'b';
  addr[2] = 'c';
  printf("3 bytes from address (after change): (%c, %c, %c)\n", addr[0],
         addr[1], addr[2]);

  if (madvise(addr, 3, MADV_DONTNEED) == -1) {
    errExit("madvise failed");
  }

  printf("3 bytes from address (after advice): (%c, %c, %c)\n", addr[0],
         addr[1], addr[2]);
}