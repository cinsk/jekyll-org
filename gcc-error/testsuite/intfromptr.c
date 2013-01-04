
void foo(int);

void
bar(void)
{
  foo("erroneous");
}


/**
 * Local Variables:
 * compile-arguments: "-Wall -c intfromptr.c"
 * description: "함수의 N번째 파라메터가 정수 타입인데도, 캐스팅 없이 포인터를 인자로 \
 *   전달한 경우에 발생합니다.  올바른 정수 타입으로 캐스팅하거나, 잘못된 인자를 썼을 가능성이 \
 *   높습니다."
 * End:
 */
