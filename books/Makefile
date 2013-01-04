
EN_SRC=$(wildcard bookinfo/*.en.tmpl)
KO_SRC=$(wildcard bookinfo/*.ko.tmpl) $(EN_SRC)

KO_TMPL=templates/header.ko.html templates/footer.ko.html
EN_TMPL=templates/header.en.html templates/footer.en.html
BOOKGEN=./bookgen.tcl

all: index.html index-ko.html

rebuild: clean all

index.html: $(EN_TMPL) $(EN_SRC) $(BOOKGEN)
	cat templates/header.en.html > index.html
	$(BOOKGEN) $(EN_SRC) >> index.html
	cat templates/footer.en.html >> index.html

index-ko.html: $(KO_TMPL) $(KO_SRC) $(BOOKGEN)
	cat templates/header.ko.html > index-ko.html
	$(BOOKGEN) $(KO_SRC) >> index-ko.html
	cat templates/footer.ko.html >> index-ko.html

clean:
	rm -f index.html index-ko.html

upload: all
	ssh $(REMOTE_USR)@$(REMOTE_HOST) "cd $(REMOTE_PREFIX); mkdir -p books;"
	tar -cf - index*.html img/*.* | ssh -C $(REMOTE_USR)@$(REMOTE_HOST) \
		"cd $(REMOTE_PREFIX)/books; tar -xf -"

