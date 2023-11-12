#cmakedefine HAVE_STDIO_H
#cmakedefine HAVE_IO_H
#cmakedefine HAVE_STDLIB_H
#cmakedefine HAVE_UNISTD_H

#ifdef HAVE_STDIO_H
#include <stdio.h>
#endif

#ifdef HAVE_IO_H
#include <io.h>
#endif

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

int main() {
  /* C.f. http://codewiki.wikidot.com/c:system-calls:write */
  if (C_WRITE(1, "This will be output to standard out\n", 36) != 36) {
    exit(1);
  }
  exit(0);
}
