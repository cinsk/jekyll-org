
void
foo(void)
{
  char c;

  switch (c) {
  case 0xffffffffffffLL:
    ;
  }
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c invcase.c"
 * description: "switch 문에서 쓴 데이터 타입의 범위를 벗어나는 case 상수식을 쓴 경우.."
 * End:
 */
