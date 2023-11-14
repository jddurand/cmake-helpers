#cmakedefine HAVE_STDLIB_H
#cmakedefine HAVE_MATH_H
#cmakedefine HAVE_FLOAT_H

#ifdef HAVE_MATH_H
#include <math.h>
#endif

#ifdef HAVE_FLOAT_H
#include <float.h>
#endif

int main() {
#if defined(C_FP_NAN)
  short x = C_FP_NAN;
#elif defined(C__FPCLASS_SNAN)
  short x = C__FPCLASS_SNAN;
#elif defined(C__FPCLASS_QNAN)
  short x = C__FPCLASS_QNAN;
#elif defined(C_FP_INFINITE)
  short x = C_FP_INFINITE;
#elif defined(C__FPCLASS_NINF)
  short x = C__FPCLASS_NINF;
#elif defined(C__FPCLASS_PINF)
  short x = C__FPCLASS_PINF;
#else
#error Nothing
#endif
    
  exit(0);
}
