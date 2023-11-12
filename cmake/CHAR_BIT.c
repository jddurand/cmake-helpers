#cmakedefine HAVE_STDLIB_H
#cmakedefine HAVE_STDIO_H
#cmakedefine HAVE_LIMITS_H

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif
#ifdef HAVE_STDIO_H
#include <stdio.h>
#endif
#ifdef HAVE_LIMITS_H
#include <limits.h>
#endif

int main() {
  fprintf(stdout, "%d", CHAR_BIT);
  exit(0);
}
