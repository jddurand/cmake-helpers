#cmakedefine HAVE_STDLIB_H

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

/* Reference: http://www.cmake.org/Wiki/CMakeTestInline */

/* Test source lifted from /usr/share/autoconf/autoconf/c.m4 */
typedef int foo_t;
static C_INLINE foo_t static_foo() {
  return 0;
}
foo_t foo() {
  return 0;
}
int main(int argc, char *argv[]){
  exit(0);
}
