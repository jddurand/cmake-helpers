#cmakedefine HAVE_STDIO_H
#cmakedefine HAVE_STDARG_H
#cmakedefine HAVE_STDLIB_H

#ifdef HAVE_STDIO_H
#include <stdio.h>
#endif
#ifdef HAVE_STDARG_H
#include <stdarg.h>
#endif
#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

static void vsnprintftest(char *string, char *fmt, ...);

int main() {
  char p[100];

  vsnprintftest(p, "%s", "test");

  exit(0);
}

static void vsnprintftest(char *string, char *fmt, ...)
{
   va_list ap;

   va_start(ap, fmt);
   C_VSNPRINTF(string, 10, fmt, ap);
   va_end(ap);
}
