#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "lib/tlpi_hdr.h"

void changingStdin() {
#define BUF_SIZE 20
  char buffer[BUF_SIZE + 1];
  int fd = open("test_new2", O_WRONLY | O_CREAT, S_IRWXU);
  ssize_t nbytes = write(fd, "hello_world", 11);
  assert(nbytes != -1);

  int fd2 = open("test_new2", O_RDONLY, 0);
  nbytes = read(fd2, buffer, BUF_SIZE);
  assert(nbytes != -1);
  printf("read: %s\n", buffer);
}

void nullTerminate() {
#define BUF_SIZE 20
  char buffer[BUF_SIZE + 1];
  int fd = open("test", O_RDONLY, 0);
  assert(fd != -1);
  ssize_t nbytes = read(fd, buffer, BUF_SIZE);
  assert(nbytes != -1);
  buffer[nbytes] = '\0';
  printf("read:%s\n", buffer);
}

void unsignedInt() {
  unsigned int v = -1;
  printf("value %u\n", v);
}

int tempFile() {
  char template[] = "/tmp/GGXXXXXX";
  int fd = mkstemp(template);
  if (fd == -1) {
    errExit("can't create temp file");
  }

  // unlink the file so that it's deleted once process ends
  // this is done automatically by the similar `tmpfile(void)` call
  if (unlink(template) == -1) {
    errExit("error unlinking");
  }

  printf("the file name is %s\n", template);
  if (write(fd, "hello", 5) == -1) {
    errExit("error");
  }

  close(fd);
}

int main() {
  tempFile();
  // nullTerminate();
  // unsignedInt();
  // changingStdin();
}