#include <stdio.h>
#include <sys/socket.h>
#include <sys/un.h>
#include "../lib/error_functions.h"
#include "../lib/tlpi_hdr.h"

int main(int argc, char* argv[]) {
  // 1. create two sockets and bind
  // 2. fork process, and connect
  // 3. fork again, create third datagram socket

  int sock_a = socket(AF_UNIX, SOCK_DGRAM, 0);
  int sock_b = socket(AF_UNIX, SOCK_DGRAM, 0);
  int sock_c = socket(AF_UNIX, SOCK_DGRAM, 0);

  struct sockaddr_un sock_a_addr;
  struct sockaddr_un sock_b_addr;
  struct sockaddr_un sock_c_addr;

  memset(&sock_a_addr, 0, sizeof(struct sockaddr_un));
  memset(&sock_b_addr, 0, sizeof(struct sockaddr_un));
  memset(&sock_c_addr, 0, sizeof(struct sockaddr_un));

  char* path_a = "/tmp/a1";
  char* path_b = "/tmp/b1";
  char* path_c = "/tmp/c1";

  remove(path_a);
  remove(path_b);
  remove(path_c);

  sock_a_addr.sun_family = AF_UNIX;
  strncpy(sock_a_addr.sun_path, path_a, strlen(path_a));
  bind(sock_a, (struct sockaddr*)&sock_a_addr, sizeof(struct sockaddr_un));

  sock_b_addr.sun_family = AF_UNIX;
  strncpy(sock_b_addr.sun_path, path_b, strlen(path_b));
  bind(sock_b, (struct sockaddr*)&sock_b_addr, sizeof(struct sockaddr_un));

  sock_c_addr.sun_family = AF_UNIX;
  strncpy(sock_c_addr.sun_path, path_c, strlen(path_c));
  bind(sock_c, (struct sockaddr*)&sock_c_addr, sizeof(struct sockaddr_un));

  if (fork() == 0) {
    // child, connect
    printf("child b is running now\n");
    if (connect(sock_b, (struct sockaddr*)&sock_b_addr,
                sizeof(struct sockaddr_un)) == -1) {
      errExit("problem with connecting sock_b");
    }
    printf("child b runs through\n");
    sleep(5);
  } else if (fork() == 0) {  // 3rd child for c
    sleep(5);
    printf("child c running now...\n");
    char buf[] = "hello world";

    int res =
        sendto(sock_c, buf, sizeof(buf), 0, (struct sockaddr*)&sock_a_addr,
               sizeof(struct sockaddr_un));
    if (res == -1) {
      errExit("problem with sendto");
    } else if (res != sizeof(buf)) {
      errExit("partial send");
    } else {
      printf("sendto is success\n");
    }
  } else {
    // parent
    printf("receivefrom parent\n");
    char buf[12];
    ssize_t rec_size = recvfrom(sock_a, buf, sizeof(buf), 0, NULL, 0);
    printf("received: %s\n", buf);
    if (rec_size == -1) {
      errExit("receive error");
    } else if (rec_size != sizeof(buf)) {
      errExit("partial receive");
    } else {
      printf("receive succeeds\n");
    }
  }
}
