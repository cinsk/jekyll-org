/* $Id$ */

int
foo(void)
{
  return;
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c retnoval.c"
 * description: "void 타입이 아닌 함수에, 값을 쓰지 않고 \"return\"만 썼을 때 \
 *   발생합니다. 함수를 void 타입으로 선언하던지, 아니면 적절한 값을 return하기 바랍니다."
 * End:
 */
