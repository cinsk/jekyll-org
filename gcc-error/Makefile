# $Id$
#
# Copyright (c) 2005  Seong-Kook Shin <cinsky at gmail.com>
#
emacs=emacs

SRC := $(wildcard testsuite/*.cc testsuite/*.[ch])

.PHONY: all clean rebuild

all: gcc-error.html
rebuild: clean all

gcc-error.html: $(SRC) mklist.el
	$(emacs) --batch -q --load mklist.el

clean:
	rm -f gcc-error.html
	rm -rf testsuite/*~ testsuite/*.o
