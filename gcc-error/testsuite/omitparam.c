
int
foo(int)
{
  return 0;
}


int
bar(int unused)
{
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c omitparam.c"
 * description: "\
 *   함수를 정의할 때, 함수 파라메터에 이름이 빠진 경우, 이 에러가 발생합니다.  예제에서 \
 *   함수 foo()의 경우에 이 에러가 발생하기 때문에, 전달된 파라메터가 쓰이지 않는 함수인 \
 *   경우, 함수 bar()와 같이 쓰기 바랍니다."
 * End:
 */
