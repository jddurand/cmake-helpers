#cmakedefine HAVE_STDLIB_H
#cmakedefine HAVE_MATH_H
#cmakedefine HAVE_FLOAT_H

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_MATH_H
#include <math.h>
#endif

#ifdef HAVE_FLOAT_H
#include <float.h>
#endif

int main() {
  int x = C_FPCLASSIFY(0.0);
  return 0;
}
