/* $Id$ */

void
foo(void)
{
  continue;
}

/**
 * Local Variables:
 * compile-arguments: "-Wall -c invcont.c"
 * description: "continue 키워드는 루프 (예: for, while. do-while) 안에서만 \
 *   의미가 있습니다.  루프 밖에서 쓰는 것은 옳지 않습니다."
 * End:
 */
