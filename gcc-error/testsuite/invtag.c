/* $Id$ */

struct s { int x, y, z; };

void
foo(void)
{
  union s foo;

  foo.x = 1;
}


/**
 * Local Variables:
 * compile-arguments: "-Wall -c invtag.c"
 * description: "struct, union 등을 써서 타입을 만들 때, 이 때 사용한 tag (예를 들어 \
 *   &quot;struct s {};&quot; 에서 tag 이름은 's'가 됩니다.) 이름을 다른 타입에서 쓰게 \
 *   되면 이 에러가 발생합니다."
 * End:
 */
