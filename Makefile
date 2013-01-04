REMOTE_USR=cinsk
REMOTE_HOST=www.cinsk.org
REMOTE_PREFIX=public_html

LATEX=latex
DVIPS=dvips
DVIPDFMX=dvipdfmx
GZIP=gzip
BZIP=bzip2
LATEX2HTML=latex2html

TOPDIR=$(shell pwd)

SUBDIRS=books cfaqs trips

export TOPDIR

include config.mak

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
	find . -name '*~' -exec rm -f {} \;

upload: all
	for f in $(SUBDIRS); do \
		$(MAKE) -C "$$f" upload; \
	done

	scp *.html $(REMOTE_USR)@$(REMOTE_HOST):$(REMOTE_PREFIX)/
	tar -cf - css | ssh $(REMOTE_USR)@$(REMOTE_HOST) \
		"cd $(REMOTE_PREFIX); tar -xf -"

