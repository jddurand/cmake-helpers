#cmakedefine HAVE_STDLIB_H
#cmakedefine HAVE_STDINT_H
#cmakedefine HAVE_STDDEF_H
#cmakedefine HAVE_SYS_STDINT_H
#cmakedefine HAVE_STDIO_H
#cmakedefine HAVE_STRING_H

#ifdef HAVE_STDLIB_H
#  include <stdlib.h>
#endif

#ifdef HAVE_STDINT_H
#  include <stdint.h>
#endif

#ifdef HAVE_STDDEF_H
#  include <stddef.h>
#endif

#ifdef HAVE_SYS_STDINT_H
#  include <sys/stdint.h>
#endif

#ifdef HAVE_STDIO_H
#include <stdio.h>
#endif

#ifdef HAVE_STRING_H
#include <string.h>
#endif

int main()
{
  char buf[64];

  if (sprintf(buf, "%zu", (size_t)1234) != 4) {
    exit(1);
  }
  else if (strcmp(buf, "1234") != 0) {
    exit(2);
  }

  exit(0);
}
