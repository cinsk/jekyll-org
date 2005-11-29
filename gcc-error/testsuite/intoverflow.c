/* $Id$ */

#include <limits.h>

enum A {
  AA = INT_MAX + 1
};

/**
 * Local Variables:
 * compile-arguments: "-Wall -c intoverflow.c"
 * description: "\
 *   정수로 취급되는 expression에서 오버플로우(overflow)가 발생할 경우에 이 경고가 \
 *   발생합니다."
 * End:
 */
