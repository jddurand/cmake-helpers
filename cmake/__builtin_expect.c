#cmakedefine HAVE_STDLIB_H

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#define C_LIKELY(x)    C__BUILTIN_EXPECT(!!(x), 1)
#define C_UNLIKELY(x)  C__BUILTIN_EXPECT(!!(x), 0)

/* Copied from https://kernelnewbies.org/FAQ/LikelyUnlikely */
int test_expect(char *s)
{
   int a;

   /* Get the value from somewhere GCC can't optimize */
   a = atoi(s);

   if (C_UNLIKELY(a == 2)) {
      a++;
   } else {
      a--;
   }
}

int main(int argc, char *argv[])
{
   test_expect("1");
   exit(0);
}
