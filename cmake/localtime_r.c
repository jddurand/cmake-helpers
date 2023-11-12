#cmakedefine HAVE_STDLIB_H
#cmakedefine HAVE_TIME_H

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_TIME_H
#include <time.h>
#endif

int main() {
  time_t time;
  struct tm result;
  C_LOCALTIME_R(&time, &result);

  exit(0);
}
