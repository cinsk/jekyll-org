
struct s;

void bar(struct s *);

void
foo(void)
{
  struct s *p;
  bar(p + 1);
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c invptr.c"
 * description: "정의가 되지 않은 (또는 알려지지 않은) 타입의 오브젝트에 수행할 수 \
 *   있는 연산은 매우 제한되어 있습니다.  이 예의 경우처럼, 포인터 연산은 할 수 없습니다. \
 *   에러가 발생하지 않게 하려면 먼저 struct s 타입의 정의를 포함시켜야 합니다."
 * todo-string: "invtype.c와 중복됨"
 * End:
 */
