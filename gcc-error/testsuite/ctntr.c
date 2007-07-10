/* $Id$ */
/* TODO: We need a better example than this */
struct s {};

void foo(void)
{
  struct s foo = (struct s) 10;
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c ctntr.c"
 * description: "\
 *   `--' 연산을 쓴 대상이 lvalue가 아닐 경우에 이 에러가 발생합니다."
 * End:
 */
