/* $Id$ */

int i;
long i;

void foo(void);
int foo(void);
/**
 * Local Variables:
 * compile-arguments: "-Wall -c conftype.c"
 * description: "이름을 선언할 때, 같은 이름을 서로 다른 타입으로 선언하면 \
 *   이 에러가 발생합니다."
 * End:
 */
