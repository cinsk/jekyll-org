#
# Makefile for `C Programming FAQs -- Korean version'
#
# $id$
#
m4=/usr/bin/m4 -P -I../m4inc

SRC:=$(wildcard *.html.m4)
DST:=$(patsubst %.html.m4, %.html, $(SRC))

SRCDVIPATH = ./cfaqs-ko.dvi

DVIPS=dvips -t a4
PS2PDF=ps2pdf
GZIP=gzip
BZIP=bzip2

.PHONY: clean all rebuild dist dist-install cfaqs tarball

all: html
tarball: cfaqs

rebuild: clean all

html: $(DST)

cfaqs: cfaqs-ko.ps.gz cfaqs-ko.ps.bz2 cfaqs-ko.pdf.gz cfaqs-ko.pdf.bz2

cfaqs-ko.ps: $(SRCDVIPATH)
	@echo -n "Converting DVI to Postscript..."
	@$(DVIPS) -o cfaqs-ko.ps $(SRCDVIPATH)	# for ps
	@echo "done."

cfaqs-ko.pdf: cfaqs-ko.ps
	@echo -n "Converting Postscript to PDF (This takes quite a time)..."
	@$(PS2PDF) cfaqs-ko.ps cfaqs-ko.pdf
	@echo "done."

cfaqs-ko.ps.gz: cfaqs-ko.ps
	@echo -n "Generating cfaqs-ko.ps.gz..."
	@$(GZIP) -9 -c cfaqs-ko.ps > cfaqs-ko.ps.gz
	@echo "done."

cfaqs-ko.pdf.gz: cfaqs-ko.pdf
	@echo -n "Generating cfaqs-ko.pdf.gz..."
	@$(GZIP) -9 -c cfaqs-ko.pdf > cfaqs-ko.pdf.gz
	@echo "done."

cfaqs-ko.ps.bz2: cfaqs-ko.ps
	@echo -n "Generating cfaqs-ko.ps.bz2..."
	@$(BZIP) -c cfaqs-ko.ps > cfaqs-ko.ps.bz2
	@echo "done."

cfaqs-ko.pdf.bz2: cfaqs-ko.pdf
	@echo -n "Generating cfaqs-ko.pdf.bz2..."
	@$(BZIP) -c cfaqs-ko.pdf > cfaqs-ko.pdf.bz2
	@echo "done."

$(DST): %.html: %.html.m4
	$(m4) $< > $@

dist:
	@rm -rf cfaqs
	@mkdir cfaqs
	@cp cfaqs-ko.ps cfaqs-ko.pdf cfaqs-ko.dvi *.html Makefile cfaqs
	@tar -cvIf cfaqs.tar.bz2 cfaqs
	@rm -rf cfaqs

dist-install: cfaqs

clean:
	rm -f $(DST)
	rm -f *~
	rm -f cfaqs-ko.pdf cfaqs-ko.pdf.gz cfaqs-ko.pdf.bz2
	rm -f cfaqs-ko.ps cfaqs-ko.ps.gz cfaqs-ko.ps.bz2
	rm -rf cfaqs
	rm -rf cfaqs.tar.bz2


