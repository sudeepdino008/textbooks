
#include <setjmp.h>
#include <stdio.h>
#include "../lib/error_functions.h"

static jmp_buf env;

void a() {
  int j = 100;
  switch (setjmp(env)) {
    case 0:
      printf("jmp target is set %d\n", j);
      break;
    case 1:
      printf("1 called (stack value j: %d)\n", j);
      break;
    default:
      fatal("invalid\n");
  }
}

void b() {
  longjmp(env, 1);
}

void c() {
  int j = 10;
  printf("value of j in c() is: %d\n", j);
  b();
}

int main(int argc, char* argv[]) {
  a();

  // SCENARIO 1
  // in the following scenario, the program doesn't crash and behaves as if the
  // stack frame was indeed resumed to "continue" executing the a() from
  // setjmp'd location (even though it's no longer there in the stack frame)
  // b();

  // SCENARIO 2
  // the program counter is set from within a(). But the stack values are picked
  // off stack frame corresponding to c(), which replaced the stackframe of a()
  // after it unwinded. (Therefore value of j turns out to be 10, rather than
  // 100)
  c();
}