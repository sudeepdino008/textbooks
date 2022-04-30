#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "../lib/error_functions.h"
#include "../lib/tlpi_hdr.h"

void assertCurrentOffset(int fd, int dfd) {
  off_t fd_off = lseek(fd, 0, SEEK_CUR);
  off_t dfd_off = lseek(dfd, 0, SEEK_CUR);
  if (fd_off == -1 || fd_off != dfd_off) {
    errExit("error getting current offset or non-matching offsets: %d and %d",
            fd_off, dfd_off);
  }

  printf("current offset matches\n");
}

int main(int argc, char* argv[]) {
  char* filename = "hellow";
  int fd = open(filename, O_CREAT | O_EXCL | O_WRONLY, S_IRWXO);
  unlink(filename);  // clean up once process is done.
  if (fd == -1) {
    errExit("error opening");
  }

  int dfd = dup(fd);
  if (dfd == -1) {
    errExit("error opening duplicate");
  }

  int fd_flags = fcntl(fd, F_GETFL);
  int dfd_flags = fcntl(dfd, F_GETFL);
  if (fd_flags == -1 || fd_flags != dfd_flags) {
    errExit(
        "error getting file status flags or non-matching status flags: %d and "
        "%d",
        fd_flags, dfd_flags);
  }

  printf("file status flags match\n");

  assertCurrentOffset(fd, dfd);

  // writing to file, another way to do it is to just use lseek
  if (write(fd, "hello", 5) == -1) {
    errExit("error writing to og file");
  }
  printf("write to original file\n");

  assertCurrentOffset(fd, dfd);

  if (write(dfd, "bye", 3) == -1) {
    errExit("error writing to dup file");
  }
  printf("wrote to duplicate file\n");

  assertCurrentOffset(fd, dfd);

  printf("looks good!\n");
}