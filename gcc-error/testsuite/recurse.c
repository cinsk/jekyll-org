/* $Id$ */

#include "recurse.c"

/**
 * Local Variables:
 * compile-arguments: "-Wall -c recurse.c"
 * description: "매크로나 #include가 재귀적으로 너무 깊게 반복될 때 발생합니다. \
 *   예를 들어 util.h가 types.h를 #include하고, types.h가 다시 util.h를 \
 *   하는 경우, 둘 중 한 파일을 소스에 포함시키면, 서로가 계속 서로를 포함시키기 때문에, \
 *   결국 컴파일러는 이 에러를 출력합니다.  이 경우 #ifndef, #define, #endif 등을 \
 *   써서 재귀적으로 포함되지 않게 합니다."
 * End:
 */
