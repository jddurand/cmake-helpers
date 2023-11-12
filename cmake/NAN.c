#cmakedefine HAVE_STDLIB_H
#cmakedefine HAVE_MATH_H

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_MATH_H
#include <math.h>
#endif

#ifdef HAVE_NAN_REPLACEMENT_USING_DIVISION
#  undef NAN
#  define NAN (0.0 / 0.0)
#else
#  ifdef HAVE_NAN_REPLACEMENT
#    undef NAN
#    define NAN (__builtin_nanf(""))
#  endif
#endif
int main() {
  float x = C_NAN;
  return 0;
}
