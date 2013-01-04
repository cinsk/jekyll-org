
#define CAT     0
#define DOG     0

void
foo(void)
{
  int a = 3;

  switch (a) {
  case 1:
  case 1:
  case CAT:
  case DOG:
  default:
    break;
  }
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c dupcase.c"
 * description: "두 case label에서 같은 상수 값이 쓰였을 때 발생합니다. \
 *   예제 코드의 경우, 1이 두 번 쓰였고, 매크로 CAT과 DOG은 0으로 변환되어 \
 *   결국 0이 두 번 쓰인 경우입니다."
 * End:
 */
