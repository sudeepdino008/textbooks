//#define _LARGEFILE64_SOURCE
#include <fcntl.h>
#include <sys/stat.h>
#include "../lib/tlpi_hdr.h"

// gcc c5/5_1.c lib/error_functions.c lib/get_num.c -g -o -current
// -F_FILE_OFFSET_BITS=1
int main(int argc, char* argv[]) {
  int fd;
  off_t off;
  if (argc != 3 || strcmp(argv[1], "--help") == 0)
    usageErr("%s pathname offset\n", argv[0]);

  fd = open(argv[1], O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
  if (fd == -1)
    errExit("open64");

  off = atoll(argv[2]);
  if (lseek(fd, off, SEEK_SET) == -1)
    errExit("lseek64");

  if (write(fd, "test", 4) == -1)
    errExit("write");
  exit(EXIT_SUCCESS);
}