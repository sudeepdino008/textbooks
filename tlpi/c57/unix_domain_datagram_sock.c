// 57.1

#include <stdio.h>
#include <sys/socket.h>
#include <unistd.h>
#include "../lib/error_functions.h"

void sender(int sender_sock) {
  printf("at sender sock\n");
  char buf[] =
      "hello world byte";
  long bufsize = sizeof(buf);

  for (;;) {
    printf("sending data...\n");

    if (sendto(sender_sock, buf, bufsize, 0, NULL, 0) != bufsize) {
      errExit("partial write. Exiting\n");
    }

    printf("sent\n");
  }
}

void receiver(int receiver_sock) {
  printf("at receiver sock\n");
  char buf[1];
  long bufsize = sizeof(buf);

  for (;;) {
    printf("ready to read!\n");
    if (recvfrom(receiver_sock, buf, bufsize, 0, NULL, 0) != bufsize) {
      errExit("partial read. Exiting\n");
    }
    printf("read!\n");

    sleep(1);
  }
}

int main(int argc, char* argv[]) {
  // 1. create a unix domain datagram socketpair
  // 2. fork a child process (which'll be the receiver)
  // 3. send stuff from parent process till the child blocks (using sendto and
  // recvfrom)
  // 4. say voila!

  int fds[2];
  int status = socketpair(AF_UNIX, SOCK_DGRAM, 0, fds);
  if (status == -1) {
    errExit("socketpair creation failed");
  }

  if (fork() == 0) {
    // child logic
    printf("%d will execute receiver logic with socket: %d\n", getpid(),
           fds[1]);
    receiver(fds[1]);
  } else {
    // parent logic
    printf("%d will execute sender logic with socket: %d\n", getpid(), fds[0]);
    sender(fds[0]);
  }
}