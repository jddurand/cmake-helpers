#cmakedefine HAVE_STDLIB_H
#cmakedefine HAVE_MATH_H

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_MATH_H
#include <math.h>
#endif

#ifdef HAVE_ISINF_REPLACEMENT
#  undef C_ISINF
#  define C_ISINF(x) (__builtin_isinf(x))
#endif

int main() {
  short x = C_ISINF(0.0);
  return 0;
}
