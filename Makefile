# $Id$

REMOTE_USR=cinsk
REMOTE_HOST=pcrc.hongik.ac.kr
REMOTE_PREFIX=public_html

LATEX=/usr/bin/latex
DVIPS=/usr/bin/dvips
DVIPDFMX=/usr/bin/dvipdfmx
GZIP=/usr/bin/gzip
BZIP=/usr/bin/bzip2

TOPDIR=$(shell pwd)

SUBDIRS=cfaqs books

export TOPDIR
export LATEX DVIPS DVIPDFMX GZIP BZIP
export REMOTE_USR REMOTE_HOST REMOTE_PREFIX

.PHONY: all subsystem clean rebuild


all: subsystem
rebuild: clean all

subsystem: 
	for f in $(SUBDIRS); do \
		$(MAKE) -C "$$f" all; \
	done

clean:
	for f in $(SUBDIRS); do \
		$(MAKE) -C "$$f" clean; \
	done

upload:
	for f in $(SUBDIRS); do \
		$(MAKE) -C "$$f" upload; \
	done

