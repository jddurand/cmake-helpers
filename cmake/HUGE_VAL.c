#cmakedefine HAVE_STDLIB_H
#cmakedefine HAVE_MATH_H
#cmakedefine HAVE_HUGE_VAL_REPLACEMENT

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_MATH_H
#include <math.h>
#endif

#ifdef HAVE_HUGE_VAL_REPLACEMENT
#  undef HUGE_VAL
#  define HUGE_VAL (__builtin_huge_val())
#endif

int main() {
  double x = -C_HUGE_VAL;
  return 0;
}
