#define _GNU_SOURCE
#include <signal.h>
#include "../lib/tlpi_hdr.h"

void handler(int sig) {
  printf("the signal is:%d\n", sig);
  fflush(NULL);
}

int main(int argc, char* argv[]) {
  sigset_t emptyset;
  sigemptyset(&emptyset);

  int i;
  for (i = 1; i < NSIG; i++) {
    struct sigaction act;
    act.sa_handler = handler;
    act.sa_flags = 0;
    act.sa_mask = emptyset;
    sigaction(i, &act, NULL);
  }

  printf("pid is: %d\n", getpid());
  printf("pausing to receive 3 signals\n");
  printf("after that, the SIGUSR1 is ignored and won't be detected...\n");

  i = 3;
  while (--i) {
    pause();
  }

  struct sigaction act;
  act.sa_handler = SIG_IGN;
  act.sa_flags = 0;
  act.sa_mask = emptyset;
  sigaction(SIGUSR1, &act, NULL);

  printf("SIGUSR1 won't be detected now...\n");
  while (true) {
    pause();
  }
}