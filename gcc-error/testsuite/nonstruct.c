/* $Id$ */

struct s {
  int i;
};


void
foo(void)
{
  struct s *p;
  char c;

  c.i = 3;
  p.i = 2;
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c nonstruct.c"
 * description: "'.' 연산자는 struct 또는 union의 멤버에 접근하기 위해 쓰이며, 다른 \
 *   곳에서 쓰일 경우 이 에러가 발생합니다.  대개 타입을 잘 못 썼거나, '.'나 '-&gt;'를 \
 *   혼동한 경우에 이 에러가 발생합니다."
 * End:
 */
