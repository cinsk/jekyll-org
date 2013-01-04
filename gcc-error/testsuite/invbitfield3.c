
struct s {
  int i: 3;
};

void
foo(void)
{
  struct s p;

  int *ip = &p.i;
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c invbitfield3.c"
 * description: "Bit field에, 주소를 얻어내는 'address of' 연산자인 &amp;를 \
 *   쓸 수 없습니다."
 * End:
 */
