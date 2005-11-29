/* $Id$ */

void
foo(void)
{
  extern int inner = 12;
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c invextern2.c"
 * description: "함수 내부에서 extern으로 선언된 object는 초기값을 가질 수 없습니다."
 * End:
 */
