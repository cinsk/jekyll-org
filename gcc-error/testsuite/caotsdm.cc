/* $Id$ */
#include <cstddef>

struct s {
  int i;
  static char c;
};

void foo(void)
{
  static s val;

  int i = offsetof(struct s, c);
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c caotsdm.cc"
 * description: "\
 *   ISO C++ 표준에 따라, offsetof 매크로는 static data member 또는 \
 *   function member에 쓸 수 없습니다."
 * End:
 */
