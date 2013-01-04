int c1, c2, c3;

void f(int op)
{
  int *p;
  switch (op) {
  case &c1:
  case p:
    break;
  }
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c panpacv.c"
 * description: "\
 *   ISO C 표준에 따라, case 문에는 integer constant expression만 쓸 수 있습니다. \
 *   본 에러는, case 값으로 포인터를 쓴 경우에 발생합니다."
 * End:
 */
