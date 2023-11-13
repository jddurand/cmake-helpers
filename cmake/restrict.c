#cmakedefine HAVE_STDLIB_H

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

static int foo (int *C_RESTRICT ip);
static int bar (int ip[]);

static int foo (int *C_RESTRICT ip) {
  return ip[0];
}

static int bar (int ip[]) {
  return ip[0];
}

int main() {
  int s[1];
  int *C_RESTRICT t = s;
  t[0] = 0;
  exit(foo (t) + bar (t));
}
