/* $Id$ */
/* TODO: We need a better example than this */
#define INITVAL 0x01
void foo(void)
{
  int i;
  int *p = &i;
  ((char *)p)++ = 4;
  i = INITVAL++;
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c ilid.c"
 * description: "\
 *   `--' 연산을 쓴 대상이 lvalue가 아닐 경우에 이 에러가 발생합니다."
 * End:
 */
