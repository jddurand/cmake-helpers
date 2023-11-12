#cmakedefine HAVE_STDLIB_H
#cmakedefine HAVE_STDARG_H

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_STDARG_H
#include <stdarg.h>
#endif

static void f(int i, ...);

int main() {
  f(0, 42);
  exit(0);
}

static void f(int i, ...) {
  va_list args1, args2;
  va_start (args1, i);
  C_VA_COPY(args2, args1);
  if (va_arg (args2, int) != 42 || va_arg (args1, int) != 42) {
    exit(1);
  }
  va_end (args1); va_end (args2);
}
