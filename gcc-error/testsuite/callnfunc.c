
void
foo(void)
{
  char *p;

  p();
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c callnfunc.c"
 * description: "함수처럼 썼으나, 함수가 아닌 경우입니다. 예제에서 보다시피, p의 타입은 \
 *   char 타입을 가리키는 포인터인데, 함수처럼 쓴 경우에 발생합니다."
 * End:
 */
