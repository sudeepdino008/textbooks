#include <stdio.h>
#include <sys/mman.h>
#include <sys/resource.h>
#include <sys/time.h>
#include "../lib/error_functions.h"

int main(int argc, char* argv[]) {
  if (argc != 2) {
    usageErr("%s <above_limit_bool(1)|below_limit_bool(0)>", argv[0]);
  }

  int above_limit = (*argv[1] == '1');

  struct rlimit limit;
  if (getrlimit(RLIMIT_MEMLOCK, &limit) == -1) {
    errExit("error getting limit");
  }

  printf("soft limit: %ld, hard limit: %ld\n", limit.rlim_cur, limit.rlim_max);
  printf("changing the limits....\n");

  limit.rlim_cur = 8192;
  limit.rlim_max = 8192;
  if (setrlimit(RLIMIT_MEMLOCK, &limit) == -1) {
    errExit("error setting limits");
  }
  printf("soft limit: %ld, hard limit: %ld\n", limit.rlim_cur, limit.rlim_max);

  void* addr = mmap(NULL, 8193, PROT_READ, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
  if (addr == MAP_FAILED) {
    errExit("mmap call failed");
  }

  int lock_len = above_limit ? 8193 : 8192;

  if (mlock(addr, lock_len) == -1) {
    errExit("mlock failed");
  }

  printf("mlock succeeded\n");
}