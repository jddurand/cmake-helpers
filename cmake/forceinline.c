#cmakedefine HAVE_STDLIB_H

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

static C_FORCEINLINE foo_t static_foo();
static foo_t foo();
typedef int foo_t;

int main(int argc, char *argv[]){
  exit(0);
}

static C_FORCEINLINE foo_t static_foo() {
  return 0;
}

static foo_t foo() {
  return 0;
}
