

void bar(void);


int
foo(void)
{
  int i = bar();

  return i;
}


/**
 * Local Variables:
 * compile-arguments: "-Wall -c invvoid2.c"
 * description: ""
 * End:
 */
