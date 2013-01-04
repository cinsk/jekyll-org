
void
foo(void)
{
  register int i;
  int *ip = &i;
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c invregs.c"
 * description: "register 키워드를 서써 선언된 변수에, 주소를 얻어내는 'address-of' \
 *   연산자를 쓸 수 없습니다.  register를 쓴다고 항상 CPU의 레지스터에 이 변수가 \
 *   위치하는 것은 아니지만, 레지스터의 사용 여부와 상관없이, 주소를 얻는 것은 옳지 않습니다."
 * End:
 */
