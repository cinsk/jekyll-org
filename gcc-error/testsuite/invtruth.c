/* $Id$ */

struct s {};

void
foo(void)
{
  struct s sa;

  if (sa)
    ;
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c invtruth.c"
 * description: ""
 * error-string: "error: invalid truth-value expression"
 * End:
 */
