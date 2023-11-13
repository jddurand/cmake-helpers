#cmakedefine HAVE_STDLIB_H
#cmakedefine HAVE_MATH_H

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_MATH_H
#include <math.h>
#endif

int main() {
  float neg = -1.0;
  float pos = 1.0;
  float res = copysignf(pos, neg);

  exit(0);
}
