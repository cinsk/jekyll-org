/* $Id$ */

void
foo(void)
{
  int i;
  *i = 3;
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c invderef.c"
 * description: "단항 연산자(unary operator)인 *는 포인터 앞에서 이 포인터가 가리키는 \
 *   대상을 가리키기 위해서(dereferencing) 쓰입니다. * 연산자가 포인터가 아닌 타입에 \
 *   쓰이면 이 에러가 발생합니다."
 * End:
 */
