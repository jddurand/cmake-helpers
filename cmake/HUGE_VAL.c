#cmakedefine HAVE_STDLIB_H
#cmakedefine HAVE_MATH_H

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_MATH_H
#include <math.h>
#endif

#ifdef HAVE_HUGE_VAL_REPLACEMENT
#  define C_HUGE_VAL (__builtin_huge_val())
#endif

int main() {
  double x = -C_HUGE_VAL;
  exit(0);
}
