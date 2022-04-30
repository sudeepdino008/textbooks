#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include "../lib/error_functions.h"
#include "../lib/tlpi_hdr.h"

// dup(fd_to_copy) -> first fd free with the same file description
int dup_fd(int fd) {
  return fcntl(fd, F_DUPFD, 0);
}

int dup2_fd(int oldfd, int newfd) {
  int fd = fcntl(oldfd, F_GETFD);
  if (fd == -1) { 
    errno = EBADF;
    return -1;
  }
  if (oldfd == newfd) {
    return newfd;
  }

  close(newfd);  // ignore status
  int status = fcntl(oldfd, F_DUPFD, newfd);
  if (status == -1) {
    return -1;
  }

  if (status != newfd) {
    close(status);
    errno = EBUSY;  // or some new error
    return -1;
  }
}

void duplicate2(int oldfd, int newfd) {
  printf("attempting duplication: %d onto %d\n", oldfd, newfd);
  int tfd_d1 = dup2_fd(oldfd, newfd);
  if (tfd_d1 == -1) {
    errExit("duplication failed\n");
  }

  printf("duplicated file: %d\n", tfd_d1);
}

void duplicate(int fd) {
  printf("attempting duplication: %d\n", fd);
  int tfd_d1 = dup_fd(fd);
  if (tfd_d1 == -1) {
    errExit("duplication failed\n");
  }

  printf("duplicated file: %d\n", tfd_d1);
}

void using_dup() {
  int tfd = open("hello", O_CREAT | O_WRONLY, S_IRUSR | S_IWUSR);
  if (tfd == -1) {
    errExit("1. opening failed\n");
  }

  duplicate(tfd);
  duplicate(tfd);

  int tfd2 = open("hello2", O_CREAT | O_WRONLY, S_IRUSR | S_IWUSR);
  if (tfd2 == -1) {
    errExit("2. opening failed\n");
  }

  printf("closing fd: %d\n", tfd);
  close(tfd);
  duplicate(tfd2);

  // should close duplicated fds too. But skipping that here.
  close(tfd2);
}

void using_dup2() {
  int tfd = open("hello", O_CREAT | O_WRONLY, S_IRUSR | S_IWUSR);
  if (tfd == -1) {
    errExit("1. opening failed\n");
  }

  duplicate2(tfd, 10);
  duplicate2(10, 20);

  close(20);

  duplicate2(20, 25);
}

int main(int argc, char* argv[]) {
  // using_dup();
  using_dup2();
}