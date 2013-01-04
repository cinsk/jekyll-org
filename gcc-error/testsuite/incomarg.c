
struct s { int a; } p;

void
foo(void)
{
  void bar(int, int);
  bar(5, p);
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c incomarg.c"
 * description: "함수 선언에 쓰인 파라메터 타입과 실제 전달된 인자의 타입이 서로 달라서 \
 *   변환이 불가능할 경우에 발생합니다."
 * End:
 */
