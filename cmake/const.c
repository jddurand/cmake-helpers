#cmakedefine HAVE_STDLIB_H

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

int main() {
  C_CONST int i = 1;
  exit(0);
}
