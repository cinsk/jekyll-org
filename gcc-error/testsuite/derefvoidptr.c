
void
foo(void)
{
  void *p;
  int i;

  i = *p;
  i = *(int *)p;
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c derefvoidptr.c"
 * description: "void 포인터는 다른 타입의 포인터로 캐스팅하기 전에, 이 포인터가 \
 *   가리키고 있는 것을 읽으려하면 안됩니다. 즉 dereferencing할 수 없습니다. \
 *   이 에러를 해결하려면, void 포인터를 다른 형태로 캐스팅해서 쓰면 됩니다."
 * End:
 */
