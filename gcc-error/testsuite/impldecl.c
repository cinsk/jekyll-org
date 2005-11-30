/* $Id$ */

void
foo(void)
{
  bar();
}


/**
 * Local Variables:
 * compile-arguments: "-Wall -c impldecl.c"
 * description: "함수가 호출되기 전에, 올바른 선언이 컴파일러에게 \
 *   알려져야 합니다."
 * End:
 */
