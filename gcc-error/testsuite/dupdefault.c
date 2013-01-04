
void
foo(void)
{
  int a = 3;

  switch (a) {
  default:
    break;
  case 1:
  case 2:
    break;
  default:
    break;
  }
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c dupdefault.c"
 * description: "한 switch 블럭에서 default label이 두 개 이상 있을 경우 \
 *   이 에러가 발생합니다. default label은 한 switch 블럭에서 하나만 존재할 \
 *   수 있습니다."
 * End:
 */
