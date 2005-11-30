/* $Id$ */

char *p = "\x1ff\400";

/**
 * Local Variables:
 * compile-arguments: "-Wall -c charrange.c"
 * description: "문자 상수나 문자열에 쓰인 escape sequence가 너무 큰 값을 가지고 있어\
 *   표현할 수 없을 때, 이 경고가 발생합니다. 이러한 값들은 적당하게 잘라집니다(truncate)."
 * End:
 */
