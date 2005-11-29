/* $Id$ */

void foo(char *s);

void
bar(void)
{
  foo(4);
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c ptrfromint.c"
 * description: "함수의 N번째 파라메터가 포인터 타입인데도, 캐스팅 없이 정수 타입을 인자로 \
 *   전달한 경우에 발생합니다.  올바른 포인터 타입으로 캐스팅하거나, 잘못된 인자를 썼을 \
 *   가능성이 높습니다."
 * End:
 */
