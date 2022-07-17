#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include "../lib/error_functions.h"

int main(int argc, char* argv[]) {
  long int sys_pg_size = sysconf(_SC_PAGESIZE);
  printf("system page size: %ld\n", sys_pg_size);

  // input file creation:

  /*
  -> export F=49.4.inp
  -> echo -n "aaa" > $F
  -> dd of=$F if=/dev/urandom bs=1 count=4093 conv=notrunc seek=3
  -> echo -n "bbb" >> $F
  -> dd of=$F if=/dev/urandom bs=1 count=4093 conv=notrunc seek=4099
  -> echo -n "ccc" >> $F
  -> dd of=$F if=/dev/urandom bs=1 count=4093 conv=notrunc seek=8195
  */

  // essentially there are 3 blocks (assuming size 4096) in the file -
  // 1st starts with aaa, 2nd starts with bbb, 3rd starts with ccc

  int fd = open("49.4.inp", O_RDONLY);
  if (fd == -1) {
    errExit("error opening file");
  }

  void* addr =
      mmap(0, 3 * sys_pg_size, PROT_READ, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
  if (addr == MAP_FAILED) {
    errExit("mapping failed");
  }

  void* page0 = mmap(addr, sys_pg_size, PROT_READ, MAP_PRIVATE | MAP_FIXED, fd,
                     2 * sys_pg_size);
  if (page0 == MAP_FAILED) {
    errExit("page0 mapping failed");
  }

  void* page1 = mmap(addr + sys_pg_size, sys_pg_size, PROT_READ,
                     MAP_PRIVATE | MAP_FIXED, fd, sys_pg_size);
  if (page1 == MAP_FAILED) {
    errExit("page1 mapping failed");
  }

  void* page2 = mmap(addr + 2 * sys_pg_size, sys_pg_size, PROT_READ,
                     MAP_PRIVATE | MAP_FIXED, fd, 0);
  if (page2 == MAP_FAILED) {
    errExit("page2 mapping failed");
  }

  printf("page0 first-3 characters: %c%c%c\n", *(char*)page0,
         *(char*)(page0 + 1), *(char*)(page0 + 2));
  printf("page1 first-3 characters: %c%c%c\n", *(char*)page1,
         *(char*)(page1 + 1), *(char*)(page1 + 2));
  printf("page2 first-3 characters: %c%c%c\n", *(char*)page2,
         *(char*)(page2 + 1), *(char*)(page2 + 2));
}