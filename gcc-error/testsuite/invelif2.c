/* $Id$ */

void
foo(void)
{
#elif defined(TWO)
  int i = 2;
#endif

};

/**
 * Local Variables:
 * compile-arguments: "-Wall -c invelif.c"
 * description: "선택적으로 컴파일할 수 있는 전처리기(preprocessor) \
 *   지시어(directivestruct)인 #if, #elif, #else, #endif 등에서, #else와 \
 *  #elif는 항상 #if ... #endif 사이에 나와야 합니다. #elif나 #else가 \
 *  단독으로 쓰일 수 없습니다."
 * End:
 */
