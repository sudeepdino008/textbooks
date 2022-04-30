#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "../lib/error_functions.h"
#include "../lib/tlpi_hdr.h"

struct iostrt {
  ssize_t nbytes;
  void* iop;
};

ssize_t writev(int fd, struct iostrt* buffer, int iocount) {
  size_t total_size = 0;
  for (int i = 0; i < iocount; i++) {
    total_size += sizeof(buffer[i].nbytes);
  }

  void* raw_buffer = malloc(total_size);

  int running = 0;
  for (int i = 0; i < iocount; i++) {
    memcpy(raw_buffer + running, buffer[i].iop, buffer[i].nbytes);
    running += buffer[i].nbytes;
  }

  return write(fd, raw_buffer, running);
}

ssize_t readv(int fd, struct iostrt* buffer, int iocount) {
  size_t total_size = 0;
  for (int i = 0; i < iocount; i++) {
    total_size += sizeof(buffer[i].nbytes);
  }

  void* raw_buffer = malloc(total_size);
  int nbytes = read(fd, raw_buffer, total_size);

  if (nbytes == -1) {
    return nbytes;
  }

  int running = 0;
  for (int i = 0; i < iocount; i++) {
    int bytes_to_read = min(buffer[i].nbytes, nbytes - running);
    if (bytes_to_read <= 0) {
      break;
    }
    memcpy(buffer[i].iop, raw_buffer, bytes_to_read);
    running += bytes_to_read;
    raw_buffer += bytes_to_read;
  }

  return nbytes;
}

int createTempFile() {
  char* filename = "hellow";
  int source = open(filename, O_CREAT | O_EXCL | O_RDWR, S_IRUSR | S_IWUSR);
  unlink(filename);
  if (source == -1) {
    errExit("error opening file");
  }

  return source;
}

void writeToFile(int fd, void* p, int nbytes) {
  int wbytes = write(fd, p, nbytes);
  if (wbytes == -1) {
    errExit("error writing bytes");
  }
  if (wbytes != nbytes) {
    errExit("partial write");
  }
}

int main(int argc, char* argv[]) {
  int source = createTempFile();

  int a = 1000;
  writeToFile(source, &a, sizeof(a));

  char buf_arr[] = "abcde";
  writeToFile(source, buf_arr, sizeof(buf_arr));

  char* buf_p = "hw";
  writeToFile(source, buf_p, 2);

  if (lseek(source, 0, SEEK_SET) == -1) {
    errExit("error setting seek position to start");
  }

  int b;
  char buf_arr2[6];
  char* buf_p2 = (char*)malloc(3);
  struct iostrt i1 = {sizeof(b), &b};
  struct iostrt i2 = {sizeof(buf_arr2), buf_arr2};
  struct iostrt i3 = {3, buf_p2};

  struct iostrt buffer[] = {i1, i2, i3};

  readv(source, buffer, 3);

  buf_p2[2] = '\0';
  buf_arr2[5] = '\0';
  printf("%d\n", *(int*)i1.iop);
  printf("%s\n", buf_arr2);
  printf("%s\n", buf_p2);

  close(source);
}