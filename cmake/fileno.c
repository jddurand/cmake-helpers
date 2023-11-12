#cmakedefine HAVE_STDIO_H
#cmakedefine HAVE_STDLIB_H

#ifdef HAVE_STDIO_H
#include <stdio.h>
#endif

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

int main() {
  C_FILENO(stdin);
  exit(0);
}
