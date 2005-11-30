/* $Id$ */
int i = '\q';

/**
 * Local Variables:
 * compile-arguments: "-Wall -c invescape.c"
 * description: "문자열(string literal) 또는 문자 상수에서 '\\'를 쓴 경우, \
 *   '\\' 뒤 문자를 특별하게 취급합니다. 이를 escape sequence라고 하는데, \
 *   쓸 수 있는 문자는 제한되어 있습니다. (예: \\a, \\b, \\f, \\n, \\r, \
 *   \\t, \\v, \\&quot;, \\?, \\\\, \\' 등)  예제 코드에서 처럼, C 언어에서 \
 *   알려지지 않은 문자가 escape sequence로 쓰인 경우, 이 경고가 출력되고 \
 *   해당 escape sequence는 일반 문자로 취급됩니다."
 * End:
 */
