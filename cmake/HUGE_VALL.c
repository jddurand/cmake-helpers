#cmakedefine HAVE_STDLIB_H
#cmakedefine HAVE_MATH_H

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_MATH_H
#include <math.h>
#endif

#ifdef HAVE_HUGE_VALL_REPLACEMENT
#  define C_HUGE_VALL (__builtin_huge_vall())
#endif

int main() {
  long double x = -C_HUGE_VALL;
  return 0;
}
