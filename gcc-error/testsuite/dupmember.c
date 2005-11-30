/* $Id$ */

struct s {
  int i;
  float i;
};

/**
 * Local Variables:
 * compile-arguments: "-Wall -c dupmember.c"
 * description: "struct이나 union에서 같은 이름이 두 개 이상의 멤버에서 \
 *   쓰였을 때 이 에러가 발생합니다.  각각 다른 이름을 써서 이 에러를 \
 *   없앨 수 있습니다."
 * End:
 */
