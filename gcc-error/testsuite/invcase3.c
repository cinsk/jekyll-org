/* $Id$ */

void
foo(void)
{
  char c;

  switch (c) {
  case 0.3:
  case "sadf":
    ;
  }
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c invcase3.c"
 * description: "case label에 쓰일 수 있는 식(expression)은 정수 \
 *   상수식(integer constant expression)입니다.  실수나 문자열 등을 쓸 수 없습니다. \
 *   정수가 아닌 다른 타입을 써야 한다면 if 등을 써야 합니다."
 * End:
 */
