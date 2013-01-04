/* TODO: We need a better example than this */
void foo(void)
{
  int i;
  int *p = &i;
  (char *)p = 4;
  1234 = 4;
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c ilia.c"
 * description: "\
 *   대입(assignment) 문장에서 왼편이 lvalue가 아닐 경우에 이 에러가 발생합니다."
 * End:
 */
