#cmakedefine HAVE_STDLIB_H
#cmakedefine HAVE_MATH_H

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_MATH_H
#include <math.h>
#endif

#ifdef HAVE_HUGE_VALF_REPLACEMENT
#  define C_HUGE_VALF (__builtin_huge_valf())
#endif

int main() {
  float x = -C_HUGE_VALF;
  return 0;
}
