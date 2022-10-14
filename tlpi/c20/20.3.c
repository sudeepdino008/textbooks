#include <signal.h>
#include "../lib/tlpi_hdr.h"

void handler(int sig) {
  printf("received signal %d\n", sig);
  fflush(NULL);
}

void sleeping_handler(int sig) {
  int id = rand();
  printf("sleeping handler (id = %d) received signal %d (now sleeping)\n", id,
         sig);
  sleep(10);
  printf("sleeping handler (id = %d) done\n", id);
  fflush(NULL);
}

int main() {
  printf("pid is: %d\n", getpid());
  printf("trying SA_RESETHAND with SIGCHLD...\n");

  sigset_t emptymask;
  sigemptyset(&emptymask);

  struct sigaction act;
  act.sa_flags = SA_RESETHAND;
  act.sa_mask = emptymask;
  act.sa_handler = handler;

  sigaction(SIGCHLD, &act, NULL);

  printf("send the SIGCHLD to process, pausing till then...\n");

  pause();

  printf(
      "subsequent calls to SIGCHLD should have the default behavior (have 5 "
      "seconds to try)\n");

  sleep(5);

  printf(
      "SIGCHLD was called (and ignored). Now moving to demonstrating "
      "SA_NODEFER...\n");

  act.sa_flags = SA_NODEFER;
  act.sa_handler = sleeping_handler;

  sigaction(SIGUSR1, &act, NULL);

  printf("send bunch of SIGUSR1 to process, pausing till then...\n");

  pause();

  printf("demo done\n");
}