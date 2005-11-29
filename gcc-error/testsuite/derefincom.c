/* $Id$ */

struct s;

void bar(struct s *);

void
foo(void)
{
  struct s *p;
  g(*p);
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c derefincom.c"
 * description: "(선언은 되었을 수 있으나) 정의되지 않은 타입을 가리키는 포인터에 \
 *   dereference 연산자인 *를 쓸 수 없습니다.  이런 경우는 쓰고자 하는 타입에 대한 정의를 \
 *   #include 등을 통해서 포함시켜 주면 됩니다."
 * End:
 */
