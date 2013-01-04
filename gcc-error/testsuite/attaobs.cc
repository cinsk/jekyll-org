struct s {
  unsigned i: 8;
};

void foo(void)
{
  s val;
  unsigned *p = &val.i;
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c attaobs.cc"
 * description: "\
 *   Bit-field 멤버에는 address-of 연산자(&amp;)를 쓸 수 없습니다."
 * End:
 */
