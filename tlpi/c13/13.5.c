#include <fcntl.h>
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include "../lib/error_functions.h"
#include "../lib/tlpi_hdr.h"

#define BUF_SIZE 10  // set to lower number for debugging

// strace -o out.trace ./current data/para.txt

// compared with the OG tail: strace -o out2.trace tail -f data/para.txt
// the buffer size is big enough (seems to use different buffer size for
// different file, sizes). 6000 is one instance. Walk back and figure out the
// right spot from which to read, and then write it to stdout WITHOUT reading
// again (this is an optimization) missing from the program below.

int main(int argc, char* argv[]) {
  int opt, lines = 10;
  // don't allow getopt to print to stderr in case of invocations like
  // `tail -n`
  opterr = 0;
  while ((opt = getopt(argc, argv, "n:")) != -1) {
    switch (opt) {
      case 'n':
        lines = atoi(optarg);
        break;
      case '?':
        // fallthrough (also not needed)
      default:
        usageErr("%s [-n num_lines] file\n", argv[0]);
    }
  }

  if (optind >= argc) {
    // expected `file` argument after options
    usageErr("%s [-n num_lines] file\n", argv[0]);
  }

  if (lines == 0) {
    exit(0);
  }

  char* filename = argv[optind];
  int fd = open(filename, O_RDONLY);
  if (fd == -1) {
    errExit("error opening the file");
  }

  char buffer[BUF_SIZE];
  ssize_t nread;
  int curr_line = 0;
  off_t curr_pos = lseek(fd, 0, SEEK_END);
  if (curr_pos == -1) {
    errExit("error finding EOF seek");
  }

  curr_pos = max(0, curr_pos - BUF_SIZE + 1);
  curr_pos = lseek(fd, curr_pos, SEEK_SET);
  if (curr_pos == -1) {
    errExit("error setting seek");
  }

  int bytes_to_read = BUF_SIZE;
  int processed_i;

  while ((nread = read(fd, buffer, bytes_to_read)) > 0) {
    // printf("current pos is %ld %d\n", curr_pos, nread);
    processed_i = nread - 1;
    for (; processed_i >= 0; processed_i--) {
      if (buffer[processed_i] == '\n') {
        lines--;
        if (lines < 0) {
          break;
        }
      }
    }

    // printf("buffer : %s lines:%d \n\n", buffer, lines);

    if (lines < 0) {
      processed_i++;  // skip the last \n
      // printf("EOL: setting to %d\n", curr_pos + processed_i);
      if (lseek(fd, curr_pos + processed_i, SEEK_SET) == -1) {
        errExit("error seeking to %ld", curr_pos);
      }
      break;  // the while
    }

    if (curr_pos >= BUF_SIZE) {
      curr_pos -= BUF_SIZE;
    } else {
      bytes_to_read = curr_pos;  // exit on next read
      curr_pos = 0;
    }

    curr_pos = lseek(fd, curr_pos, SEEK_SET);
    // printf("setting to %d\n", curr_pos);
    if (curr_pos == -1) {
      errExit("error seeking to %ld", curr_pos);
    }
  }

  if (nread == -1) {
    errExit("error reading file");
  }

  // processed_i is the offset from which we should print
  char* mode = "r";
  FILE* file_stream = fdopen(fd, mode);
  if (setvbuf(file_stream, NULL, _IOLBF, 0) != 0) {
    errExit("can't set line-buffering for the opened file");
  }

  char* ch = (char*)malloc(sizeof(char));
  while ((nread = fread(ch, sizeof(char), 1, file_stream)) > 0) {
    if (fwrite(ch, sizeof(char), 1, stdout) == -1) {
      errExit("error writing to stdout");
    }
  }

  if (nread == -1) {
    errExit("error reading file");
  }

  if (close(fd) == -1) {
    errExit("can't close file");
  }
}