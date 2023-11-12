#cmakedefine HAVE_STDLIB_H
#cmakedefine HAVE_MATH_H

#if HAVE_STDLIB_H
#include <stdlib.h>
#endif

#if HAVE_MATH_H
#include <math.h>
#endif

int main() {
  C_LOG2(1.0);
  exit(0);
}
