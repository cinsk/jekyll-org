/* $Id$ */
void f(int a, ...) __attribute__ ((format (printf, 2)));

/**
 * Local Variables:
 * compile-arguments: "-Wall -c wnoasfa.c"
 * description: "\
 *   GCC 확장 기능인 __attribute__ 키워드를 쓸 때, 전달한 인자의 갯수가 틀린 \
 *   경우에 이 에러가 발생합니다.  이 예제에서 함수 f()에 사용한 `format'의 경우,\
 *   세 개의 인자를 전달해야 하는데, 두 개의 인자만 전달했기 때문에, 이 에러가 \
 *   발생합니다."
 * End:
 */
