#cmakedefine HAVE_STDLIB_H
#cmakedefine HAVE_MATH_H

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_MATH_H
#include <math.h>
#endif

int main() {
  long double neg = -1.0;
  long double pos = 1.0;
  long double res = C_COPYSIGNL(pos, neg);

  exit(0);
}
