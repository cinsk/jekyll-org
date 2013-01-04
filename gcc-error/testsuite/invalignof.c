
struct foo {
  int x;
  int b: 3;
  char y;
};


int
foo(struct foo f)
{
  int i = __alignof__(f.b);

  return i;
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c invalignof.c"
 * description: ""
 * End:
 */
