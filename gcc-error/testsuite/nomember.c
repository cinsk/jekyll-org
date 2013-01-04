

struct abc {
  int a, b;
};

void
foo(void)
{
  struct abc a;

  a.c = 0;
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c nomember.c"
 * description: ""
 * End:
 */
