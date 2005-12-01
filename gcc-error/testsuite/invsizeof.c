/* $Id$ */

void bar(int i);

int
foo(void)
{
  int i = sizeof(bar);

  return i;
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -pedantic -c invsizeof.c"
 * description: ""
 * End:
 */
