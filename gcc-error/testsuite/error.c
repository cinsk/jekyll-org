/* $Id$ */

#error Abracadabra..

/**
 * Local Variables:
 * compile-arguments: "-Wall -c error.c"
 * description: "\
 *   이 에러는 컴파일러에게 소스가 전달되기 전, 전처리기(preprocessor)에 의해 발생합니다. \
 *   Preprocessor는 #error로 시작하는 문장을 만나면, 바로 처리를 멈추고, \
 *   \"#error ...\"를 출력합니다.  이는 대개, 프로그램 소스가 특별한 환경을 요구하는 경우, \
 *   (예: 컴파일하기 적당하지 않은 경우) 그 조건을 만족하지 못했을 때, 도움말을 출력하는 \
 *   목적으로 쓰입니다.</p>\
 *   <p>ISO C에서는 미리 정의된(predefined) 매크로 상수를 정의하고 있고, 컴파일러에 따라 \
 *   추가적으로 더 제공합니다. #error의 경우, 이런 매크로들과 같이 쓰이는 경우가 일반적이므로 \
 *   자세한 것은 \
 *   <a href=\"http://gcc.gnu.org/onlinedocs/cpp/Predefined-Macros.html\">Predefined Macros</a>를 참고하기 바랍니다."
 * End:
 */
