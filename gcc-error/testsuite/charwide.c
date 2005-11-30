/* $Id$ */

char a[] = L"abc";

/**
 * Local Variables:
 * compile-arguments: "-Wall -c charwide.c"
 * description: "Wide character 상수는 문자 상수나 문자열 앞에 'L'을 \
 *   붙여 나타내며 이 타입은 wchar_t 입니다. 이 에러는 wchar_t 타입의 \
 *   문자열을 char 타입의 배열에 초기값으로 썼을 경우에 발생합니다. \
 *   따라서 배열을 wchar_t type으로 바꾸거나 char 타입의 문자열 \
 *   상수를 써서 (즉 'L'을 빼서) 이 에러를 수정할 수 있습니다."
 * End:
 */
