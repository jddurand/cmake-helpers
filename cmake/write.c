#cmakedefine HAVE_STDIO_H
#cmakedefine HAVE_STDLIB_H
#cmakedefine HAVE_UNISTD_H
#cmakedefine HAVE_FCNTL_H

#ifdef HAVE_STDIO_H
#include <stdio.h>
#endif

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#ifdef HAVE_FCNTL_H
#include <fcntl.h>
#endif

#include <windows.h>

int main() {
  /* C.f. http://codewiki.wikidot.com/c:system-calls:write */
  int filedesc = open("testfile.txt", O_CREAT|O_WRONLY|O_TRUNC);;

  if (filedesc < 0) {
    exit(1);
  }
  if (C_WRITE(1, "This will be output to standard out\n", 36) != 36) {
    exit(1);
  }

  close(filedesc);

  exit(0);
}
