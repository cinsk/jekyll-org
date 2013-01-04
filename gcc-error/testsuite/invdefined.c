
#undef defined
#define defined abc

/**
 * Local Variables:
 * compile-arguments: "-Wall -c invdefined.c"
 * description: "전처리기(preprocessor)의 연산자인 defined는 매크로 이름으로 쓰일 \
 *   수 없으며, 정의를 취소할 수도 없습니다."
 * End:
 */
