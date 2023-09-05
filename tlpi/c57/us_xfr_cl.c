/* 57.2

gcc -g -o server us_xfr_sv.c ../lib/error_functions.c
./server

us_xfr_cl.c

   An example UNIX domain stream socket client. This client transmits contents
   of stdin to a server socket.

   See also us_xfr_sv.c.
*/
#include "us_xfr.h"
int main(int argc, char* argv[]) {
  struct sockaddr_un addr;
  int sfd;
  ssize_t numRead;
  char buf[BUF_SIZE];

  sfd = socket(AF_UNIX, SOCK_STREAM, 0); /* Create client socket */
  if (sfd == -1)
    errExit("socket");

  /* Construct server address, and make the connection */

  memset(&addr, 0, sizeof(struct sockaddr_un));
  addr.sun_family = AF_UNIX;
  strncpy(&addr.sun_path[1], SV_SOCK_PATH, strlen(SV_SOCK_PATH));

  if (connect(sfd, (struct sockaddr*)&addr,
              sizeof(sa_family_t) + strlen(SV_SOCK_PATH) + 1) == -1)
    errExit("connect");

  /* Copy stdin to socket */

  while ((numRead = read(STDIN_FILENO, buf, BUF_SIZE)) > 0)
    if (write(sfd, buf, numRead) != numRead)
      fatal("partial/failed write");

  if (numRead == -1)
    errExit("read");

  exit(EXIT_SUCCESS); /* Closes our socket; server sees EOF */
}