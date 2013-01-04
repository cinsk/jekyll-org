
void
foo(void)
{
  case 0xffffffff:
    ;
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c invcase2.c"
 * description: "case는 switch 블럭 안에서만 쓸 수 있습니다."
 * End:
 */
