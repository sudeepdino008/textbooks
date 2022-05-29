/* copy.c

   Copy the file named argv[1] to a new file named in argv[2].
*/

// command to execute:
// make CFLAG_ARGS="-DBUF_SIZE=100" clean current && time ./current
// c13/source_rand_file c13/dest_rand_file

// buffer_size=default
//      no_sync    sync
// real 0m0.065s   0m2.828s
// user 0m0.003s   0m0.000s
// sys  0m0.036s   0m0.282s

// buffer_size=100
//      no_sync    sync
// real 0m0.251s   0m29.118s
// user 0m0.014s   0m0.091s
// sys  0m0.142s   0m2.469s

// buffer_size=1
//      no_sync    sync
// real 0m20.876s   (didn't complete execution in dozens of minutes)
// user 0m0.721s
// sys  0m12.306s

// buffer_size=100000
//      no_sync    sync
// real 0m0.018s   0.161s
// user 0m0.000s   0.000s
// sys  0m0.012s   0.021s

#include <fcntl.h>
#include <sys/stat.h>
#include "../lib/tlpi_hdr.h"

#ifndef BUF_SIZE /* Allow "cc -D" to override definition */
#define BUF_SIZE 1024
#endif
int main(int argc, char* argv[]) {
  int inputFd, outputFd, openFlags;
  mode_t filePerms;
  ssize_t numRead;
  char buf[BUF_SIZE];

  if (argc != 3 || strcmp(argv[1], "--help") == 0)
    usageErr("%s old-file new-file\n", argv[0]);

  /* Open input and output files */

  inputFd = open(argv[1], O_RDONLY);
  if (inputFd == -1)
    errExit("opening file %s", argv[1]);

  openFlags = O_CREAT | O_WRONLY | O_TRUNC | O_SYNC;
  filePerms =
      S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH; /* rw-rw-rw- */
  outputFd = open(argv[2], openFlags, filePerms);
  if (outputFd == -1)
    errExit("opening file %s", argv[2]);

  /* Transfer data until we encounter end of input or an error */

  while ((numRead = read(inputFd, buf, BUF_SIZE)) > 0)
    if (write(outputFd, buf, numRead) != numRead)
      fatal("write() returned error or partial write occurred");
  if (numRead == -1)
    errExit("read");

  if (close(inputFd) == -1)
    errExit("close input");
  if (close(outputFd) == -1)
    errExit("close output");

  exit(EXIT_SUCCESS);
}