#include <errno.h>
#include <memory.h>
#include <stdio.h>
#include <stdlib.h>
#include "../lib/error_functions.h"

extern char** environ;

// putenv  NAME=VALUE (stored as is -- pointer)
//  getenv (returnsn pointer to value in envlist entry)

int setenv_check(char* entry) {
  // check for null name, or name containing '=' (EINVAL)
  // insufficient memory to add the entry (ENOMEM)
  if (entry == NULL || *entry == '\0') {
    errno = EINVAL;
    return -1;
  }

  int nlet = 0;
  char* c_entry = entry;
  while (*entry != '\0') {
    if (*entry == '=') {
      errno = EINVAL;
      return -1;
    }
    entry++;
    nlet++;
  }

  return nlet;
}

int c_setenv(char* name, char* value, int overwrite) {
  // creates copies of name and value

  int s_name = setenv_check(name);
  if (s_name == -1) {
    return -1;
  }

  int s_value = setenv_check(value);
  if (s_value == -1) {
    return -1;
  }
  // TODO: unclear on how to account of "insufficient memory" error

  if (overwrite != 0 || getenv(name) == NULL) {
    char* buffer = (char*)malloc(s_name + s_value + 2);

    int status = sprintf(buffer, "%s=%s", name, value);
    if (status == -1) {
      return -1;
    }
    buffer[s_name + s_value + 1] = '\0';
    putenv(buffer);
  }

  return 0;
}

int len(char* str) {
  if (str == NULL || *str == '\0') {
    return 0;
  }

  int count = 0;
  while (*str != '\0') {
    count++;
    str++;
  }
  return count;
}

int c_unsetenv(char* name) {
  // check for null name
  // interates through the environment list to find multiple versions of name

  if (name == NULL || *name == '\0') {
    errno = EINVAL;
    return -1;
  }

  for (char** c_environ = environ; *c_environ != NULL; c_environ++) {
    char* c_name = name;
    char* cc_environ = *c_environ;
    while (*c_name != '\0' && *cc_environ != '\0' && *cc_environ != '=' &&
           *c_name == *cc_environ) {
      c_name++;
      cc_environ++;
    }

    if (*c_name == '\0' && *cc_environ == '=') {
      puts("unsetting");
      int status = unsetenv(name);
      if (status == -1) {
        return -1;
      }
    }
  }

  return 0;
}

void print_env() {
  char** c_environ = environ;
  for (; *c_environ != NULL; c_environ++) {
    puts(*c_environ);
  }
  puts("\n");
}

// implement setenv(), unsetenv()
int main(int argc, char* argv[]) {
  print_env();
  int status = c_setenv("hello", "world", 0);
  if (status == -1) {
    errExit("can't put stuff\n");
  }

  puts("after putting....");
  print_env();

  status = c_setenv("hello", "world2", 0);
  if (status == -1) {
    errExit("can't put stuff\n");
  }

  puts("overwrite: 0; shouldn't update....");
  print_env();

  status = c_setenv("hello", "world3", 1);
  if (status == -1) {
    errExit("can't put stuff\n");
  }

  status = c_setenv("hello2", "world1", 0);
  if (status == -1) {
    errExit("can't put stuff\n");
  }

  puts("after updating and putting....");
  print_env();

  status = c_unsetenv("hello");
  if (status == -1) {
    errExit("can't put stuff\n");
  }

  puts("after unsetting hello....");
  print_env();

  status = c_unsetenv("hello3");
  if (status == -1) {
    errExit("can't put stuff\n");
  }

  puts("after unsetting hello3 (non-existent)....");
  print_env();
}