// 5.2

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "../lib/error_functions.h"

static const char* FILE_NAME = "tmp.out";

void createFile() {
  int expf = open(FILE_NAME, O_WRONLY | O_CREAT, 0600);
  if (expf == -1) {
    errExit("can't open file");
  }

  ssize_t wbytes;
  if ((wbytes = write(expf, "djfdf", 5)) != 5) {
    errExit("unexpected #bytes written %d", wbytes);
  }

  close(expf);
}

int main(int argc, char* argv[]) {
  createFile();
  int expf = open(FILE_NAME, O_RDWR | O_APPEND, 0600);

  off_t nseek = lseek(expf, 0, 0);
  if (nseek == -1) {
    errExit("invalid seek position %ld", (long int)nseek);
  } else {
    printf("new file position %ld\n", (long int)nseek);
  }

  ssize_t wbytes;
  if ((wbytes = write(expf, "ee", 2)) != 2) {
    errExit("2. unexpected #bytes written %d", wbytes);
  }

  close(expf);
}

// From manpage:
// If  the O_APPEND file status flag is set on the open file description, then a
// write(2) always moves the file offset to the end of the
//        file, regardless of the use of lseek().