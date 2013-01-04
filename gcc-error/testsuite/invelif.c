

void
foo(void)
{
#if defined(ONE)
  int i = 1;
#elif defined(TWO)
  int i = 2;
#else
  int i = 3;
#elif defined(FOUR)
  int i = 4;
#endif
};

/**
 * Local Variables:
 * compile-arguments: "-Wall -c invelif.c"
 * description: "선택적으로 컴파일할 수 있는 전처리기(preprocessor) \
 *   지시어(directivestruct)인 #if, #elif, #else, #endif 등에서, #elif는 \
 *   항상 #else 앞에 나와야 합니다."
 * End:
 */
