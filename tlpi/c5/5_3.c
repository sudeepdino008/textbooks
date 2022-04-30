#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include "../lib/error_functions.h"
#include "../lib/tlpi_hdr.h"

// filename, nbytes, atomic_bool
int main(int argc, char* argv[]) {
  if (argc != 4 && argc != 3) {
    usageErr("use as %s filename nbytes [x]\n", argv[0]);
  }

  int atomic = 1;
  if (argc == 4 && *argv[3] != 'x') {
    usageErr("use as %s filename nbytes [x]\n", argv[0]);
  } else if (argc == 4) {
    atomic = 0;
  }

  char* filename = argv[1];
  long long nbytes = atoll(argv[2]);

  int flags = O_WRONLY | O_CREAT | ((atomic == 1) ? O_APPEND : 0);
  int fd = open(filename, flags, 0600);

  while (nbytes--) {
    if (atomic == 0) {
      if (lseek(fd, 0, SEEK_END) == -1) {
        errExit("error seeking\n");
      }
    }
    if (write(fd, "1", 1) != 1) {
      errExit("error writing 1 byte to file\n");
    }
  }

  close(fd);
}