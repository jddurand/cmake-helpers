#cmakedefine HAVE_STDLIB_H
#cmakedefine HAVE_MATH_H

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_MATH_H
#include <math.h>
#endif

int main() {
  double x = C_LOG2(1.0);
  exit(0);
}
