#cmakedefine HAVE_STDLIB_H
#cmakedefine HAVE_MATH_H

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_MATH_H
#include <math.h>
#endif

#ifdef HAVE_NAN_REPLACEMENT_USING_DIVISION
#  define C_NAN (0.0 / 0.0)
#else
#  ifdef HAVE_NAN_REPLACEMENT
#    define C_NAN (__builtin_nanf(""))
#  endif
#endif
int main() {
  float x = C_NAN;
  exit(0);
}
