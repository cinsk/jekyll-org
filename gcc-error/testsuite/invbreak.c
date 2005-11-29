/* $Id$ */

void
foo(void)
{
  break;
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c invbreak.c"
 * description: "break 키워드는 switch, while, do-while, for 내부에서만 쓰일 수 \
 *   있습니다. 다른 곳에서 쓸 경우, 이 에러가 발생합니다."
 * End:
 */
