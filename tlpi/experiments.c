#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <assert.h>
#include <errno.h>
#include "lib/tlpi_hdr.h"

void changingStdin() {
    #define BUF_SIZE 20
    char buffer[BUF_SIZE+1];
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
    char buffer[BUF_SIZE+1];
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

int main() {
    //nullTerminate();
    //unsignedInt();
    changingStdin();
  
}