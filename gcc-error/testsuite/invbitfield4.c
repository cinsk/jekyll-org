
struct s {
  int i: 3;
};

void
foo(void)
{
  struct s p;
  int i = sizeof(p.i);
  i = 3;
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c invbitfield4.c"
 * description: "Bit field에 sizeof 연산자를 쓸 수 없습니다."
 * End:
 */
