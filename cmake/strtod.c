#cmakedefine HAVE_STDLIB_H

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

int main() {
  char *string = "3.14Stop";
  char *stopstring = NULL;

  C_STRTOD(string, &stopstring);
  exit(0);
}
