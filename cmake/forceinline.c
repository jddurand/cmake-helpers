#cmakedefine HAVE_STDLIB_H

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

typedef int foo_t;
static C_FORCEINLINE foo_t static_foo() {
  return 0;
}
foo_t foo() {
  return 0;
}
int main(int argc, char *argv[]){
  exit(0);
}
