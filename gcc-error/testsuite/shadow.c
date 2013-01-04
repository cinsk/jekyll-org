
int
foo(int i)
{
  short i = 3;

}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c shadow.c"
 * description: "\
 *   함수 정의 또는 기타 블럭 구조에서 블럭 안에서 선언한 이름이, 블럭 밖에서 선언한 이름과 \
 *   같을 경우에 이 경고가 발생합니다. 이 경우, 블럭 밖에서 선언한 이름을 쓸 수 없습니다. \
 *   따라서, 가능하면 서로 같지 않게 이름짓는 것이 좋습니다."
 * End:
 */
