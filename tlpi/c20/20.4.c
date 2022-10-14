#include <signal.h>
#include "../lib/tlpi_hdr.h"

int siginterrupt(int sig, int flag) {
  struct sigaction prev_act;
  if (sigaction(sig, NULL, &prev_act) == -1) {
    return -1;
  }

  if (flag) {
    prev_act.sa_flags &= ~SA_RESTART;
  } else {
    prev_act.sa_flags |= SA_RESTART;
  }

  return sigaction(sig, &prev_act, NULL);
}

int main(int argc, char* argv[]) {}