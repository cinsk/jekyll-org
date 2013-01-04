#line -1 "foo.c"
#line hello
#0x32
/**
 * Local Variables:
 * compile-arguments: "-Wall -c line.c"
 * description: "\
 *   Preprocessor directive인 #line 뒤에는 항상 (10진수) 양수가 나와야 합니다. \
 *   또한 #line 대신 #만 쓸 수도 있기 때문에 &quot;#-3&quot;처럼 쓴 경우에도 \
 *   이 에러가 발생합니다."
 * End:
 */
