/* $Id$ */

void bar(int);

void
foo(void)
{
  bar(5, 4);
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c manyarg.c"
 * description: "함수 선언에 쓰인 파라메터의 갯수보다 실제 전달된 인자의 갯수가 많을 경우에 \
 *   발생합니다."
 * End:
 */
