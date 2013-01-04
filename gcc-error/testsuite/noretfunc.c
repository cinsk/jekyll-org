
foo(void)
{
  return 0;
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c noretfunc.c"
 * description: "함수의 리턴 타입을 생략할 경우에 발생합니다. 리턴 형이 생략된 함수는 \
 *   자동적으로 int 타입을 리턴하는 것으로 간주하지만, 좋은 코딩 습관이 아닙니다.  올바르게 \
 *   리턴 타입을 써 주는 것이 좋습니다."
 * End:
 */
