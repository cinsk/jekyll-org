/* $Id$ */
void f(...)
{
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c vlal.c"
 * description: "\
 *   ISO C에서 가변 인자 리스트를 받는 함수는 반드시 하나 이상의 고정된 파라메터를 제공해야 \
 *   합니다. 이 예제에서 함수 f()는 고정된 파라메터가 하나도 없기 때문에 이 에러가 발생합니다."
 * End:
 */
