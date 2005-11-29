/* $Id$ */

int
foo(void)
{

}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c nvoidfunc.c"
 * description: "함수의 리턴 타입이 void가 아닌데도, 적절한 return 문장이 없을 때 \
 *   이 경고가 발생합니다.  이 경우, 함수의 리턴 타입을 void로 고치거나, 적당하게 return \
 *   문장을 넣어주면 됩니다."
 * End:
 */
