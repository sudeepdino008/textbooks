#include <fcntl.h>  // file control operations
#include <stdio.h>
#include <unistd.h>
#include "../lib/tlpi_hdr.h"

int main(int argc, char* argv[]) {
  if (argc != 3) {
    fatal("must provide 2 arguments");
  }

  char* source = argv[1];
  char* destination = argv[2];

  int source_fd = open(source, O_RDONLY);
  if (source_fd == -1) {
    errExit("failed to open source file");
  }

  int dest_fd = open(destination, O_WRONLY | O_CREAT | O_TRUNC,
                     S_IRWXU);  /// can also use creat

  char buffer[BUFSIZ];
  ssize_t nbytes;
  while (nbytes = read(source_fd, buffer, BUFSIZ), nbytes > 0) {
    // can do partial write after which the call might return (due to signal
    // interrupts). ideally need to write again in such a case. but if partial
    // write occurs otherwise, there's probably an error and there's no failure
    // handling mechanism below (in fact it 'succeeds' silently)
    ssize_t nwritten = write(dest_fd, buffer, nbytes);
    if (nwritten == -1) {
      errExit("error writing in destination file");
    }
  }

  if (nbytes == -1) {
    errExit("error reading from source");
  }

  int status = fsync(dest_fd);  // have fsync since close gives no guarantee
                                // that data is flushed
  if (status == -1) {
    if (errno != EINVAL) {  // EINVAL happens when destination if fifo, sockets
                            // etc. which doesn't support fsync
      errExit("error flushing the destination file");
    }
  }

  status = close(source_fd);
  if (status == -1) {
    errExit("error closing the source file");
  }

  status = close(dest_fd);
  if (status == -1) {
    close(dest_fd);
  }
}
