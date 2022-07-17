#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include "../lib/error_functions.h"

int main(int argc, char* argv[]) {
  // create an input file
  // mmap input into the memory - PROT_READ, MAP_SHARED | MAP_FILE
  // mmap output into the memory - PROT_READ|PROT_WRITE, MAP_SHARED | MAP_FILE
  // use memcpy
  if (argc != 3) {
    usageErr("%s <input_file> <output_file>\n", argv[0]);
  }

  char* inp_file = argv[1];
  char* out_file = argv[2];

  int inp_fd = open(inp_file, O_RDONLY);
  if (inp_fd == -1) {
    errExit("error opening input file");
  }

  struct stat buf;
  if (fstat(inp_fd, &buf) != 0) {
    errExit("fstat failed");
  }

  void* inpmap_addr =
      mmap(0, buf.st_size, PROT_READ, MAP_PRIVATE | MAP_FILE, inp_fd, 0);

  if (inpmap_addr == MAP_FAILED) {
    errExit("mapping failed (input)");
  }

  if (close(inp_fd) == -1) {
    errExit("file closing failed (input)");
  }

  int out_fd = open(out_file, O_RDWR | O_CREAT, S_IRWXU | S_IWGRP | S_IWOTH);

  if (ftruncate(out_fd, buf.st_size) == -1) {
    errExit("file truncation failed");
  }

  void* outmap_addr = mmap(0, buf.st_size, PROT_WRITE, MAP_SHARED, out_fd, 0);

  if (outmap_addr == MAP_FAILED) {
    errExit("mapping failed (output)");
  }

  if (close(out_fd) == -1) {
    errExit("error closing file");
  }

  memcpy(outmap_addr, inpmap_addr, buf.st_size);

  if (munmap(inpmap_addr, buf.st_size) != 0) {
    errExit("error unmapping (input)");
  }

  if (munmap(outmap_addr, buf.st_size) != 0) {
    errExit("error unmapping (output)");
  }
}