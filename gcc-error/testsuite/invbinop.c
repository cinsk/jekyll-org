/* $Id$ */

struct s {
  int i;
};

void
foo(void)
{
  struct s p;
  int i = (p != 0);
  int j = p + 3;
  int *ip = 0;
  double *dp = 0;

  while (p * 2 + i - j) {
    ip - dp;
  }
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c invbinop.c"
 * description: "두 개의 피연산자(operand)를 받는 binrary operator \
 *   (예: +, -, *, /, ==, !=, &lt;, &gt;, &lt;=, &gt;=, &amp;, |, 등)들의 \
 *   피연산자의 타입은 scalar(스칼라, 즉 정수나 실수) 타입이어야 합니다. \
 *   struct이나 union 타입이 올 수 없습니다. </p><p> 예를 들어, \
 *   조건식(conditional expression)이 필요한 if, for, while, do-while에서 \
 *   struct이나 union을 쓸 경우 이 에러가 발생합니다.  또, 서로 다른 타입의 \
 *   포인터에 연산을 할 때에도 발생할 수 있습니다. 또, \"? :\" 연산자를 쓸 때, \
 *   \"e1 ? e2 : e3\" 꼴에서 e1이 스칼라 타입이 아닌 경우에도 이 에러가 \
 *   발생합니다."
 * End:
 */
