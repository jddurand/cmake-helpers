#cmakedefine HAVE_STDIO_H
#cmakedefine HAVE_STDLIB_H
#cmakedefine HAVE_UNISTD_H

#ifdef HAVE_STDIO_H
#include <stdio.h>
#endif

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

int main() {
  C_WRITE(stderr, "", 1);
  exit(0);
}
