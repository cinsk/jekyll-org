/* $Id$ */

struct s {};

void
foo(void)
{
  struct s st;
  int i;

  i = st;
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c incomassign.c"
 * description: "대입 연산에서 연산자 '='의 왼쪽, 오른쪽의 타입이 서로 완전히 다릅니다."
 * End:
 */
