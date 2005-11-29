/* $Id$ */

void
foo(void)
{
  char *cp;
  int i;

  i = cp;
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c intptrassign.c"
 * description: "대입 연산에서 포인터 타입의 값을 졍수형 타입의 변수에 저장하려 했을때 \
 *   이 경고가 발생합니다. 이 경고를 없애려면, 포인터 값을 정수형으로 강제 캐스팅해야 합니다."
 * End:
 */
