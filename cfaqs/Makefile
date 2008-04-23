#
# $Id$
#

ifndef TOPDIR
	TOPDIR=$(shell pwd)/..
	include $(TOPDIR)/config.mak
endif

SRC=arrayptr.tex charstr.tex floats.tex nullptr.tex sproblem.tex style.tex \
	bib.tex decinit.tex libfunc.tex pointer.tex standard.tex sysdep.tex \
	boolexpr.tex expr.tex memalloc.tex preface.tex stdio.tex toolres.tex \
	cfaqs-ko.tex ext.tex misc.tex preproc.tex struct.tex vlal.tex \
	cfaqs-ko-1.epic

.PHONY=all rebuild clean upload

all: cfaqs-ko.pdf cfaqs-ko.pdf.gz cfaqs-ko.pdf.bz2 html

rebuild: clean all

cfaqs-ko.dvi: $(SRC)
	$(LATEX) cfaqs-ko.tex
	$(LATEX) cfaqs-ko.tex
	$(LATEX) cfaqs-ko.tex

cfaqs-ko.ps: cfaqs-ko.dvi
	$(DVIPS) -t a4 -o cfaqs-ko.ps cfaqs-ko.dvi

cfaqs-ko.pdf: cfaqs-ko.dvi
	$(DVIPDFMX) -p a4 -t cfaqs-ko.dvi

cfaqs-ko.ps.gz: cfaqs-ko.ps
	$(GZIP) -9 -c cfaqs-ko.ps > cfaqs-ko.ps.gz

cfaqs-ko.pdf.gz: cfaqs-ko.pdf
	$(GZIP) -9 -c cfaqs-ko.pdf > cfaqs-ko.pdf.gz

cfaqs-ko.ps.bz2: cfaqs-ko.ps
	$(BZIP) -9 -c cfaqs-ko.ps > cfaqs-ko.ps.bz2

cfaqs-ko.pdf.bz2: cfaqs-ko.pdf
	$(BZIP) -9 -c cfaqs-ko.pdf > cfaqs-ko.pdf.bz2

html: cfaqs-ko.dvi latex2html.conf
	$(LATEX2HTML) --init_file latex2html.conf cfaqs-ko

clean: 
	#rm -f cfaqs-ko.ps.gz cfaqs-ko.ps.bz2
	rm -f cfaqs-ko.pdf.gz cfaqs-ko.pdf.bz2
	rm -f cfaqs-ko.pdf
	rm -f cfaqs-ko.dvi
	rm -f cfaqs-ko.aux cfaqs-ko.log cfaqs-ko.toc
	rm -rf html

upload: all
	ssh $(REMOTE_USR)@$(REMOTE_HOST) \
		"cd && mkdir -p $(REMOTE_PREFIX)/cfaqs/html"
	scp index*.html cfaqs-ko.ps* cfaqs-ko.pdf* \
		$(REMOTE_USR)@$(REMOTE_HOST):$(REMOTE_PREFIX)/cfaqs/
	scp html/* $(REMOTE_USR)@$(REMOTE_HOST):$(REMOTE_PREFIX)/cfaqs/html/
