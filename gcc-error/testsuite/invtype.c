/* $Id$ */


struct s;

void
foo(void)
{
  struct s bar();
  bar();
}


void car(struct s *);

void
bar(void)
{
  struct s *p;
  car(p + 1);
}


/**
 * Local Variables:
 * compile-arguments: "-Wall -c invtype.c"
 * description: "주어진 타입이 완전히 정의되지 않은 상황에서, 이 타입을 쓸 수 없습니다. \
 *   이 예에서 함수 bar()의 리턴 타입은 struct s이지만, 아직 정의되지 않았기 때문에, \
 *   bar()를 호출하는 것은 옳지 않습니다.  이 문제를 해결하려면 먼저 struct s를 \
 *   정의해야 합니다."
 * End:
 */
