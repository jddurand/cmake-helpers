#cmakedefine HAVE_STDLIB_H
#cmakedefine HAVE_MATH_H

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_MATH_H
#include <math.h>
#endif

#ifdef HAVE_ISNAN_REPLACEMENT
#  undef C_ISNAN
#  define C_ISNAN(x) (__builtin_isnan(x))
#endif

int main() {
  short x = C_ISNAN(0.0);
  return 0;
}
