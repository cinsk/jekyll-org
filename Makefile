
.PHONY: clean all rebuild www articles

ARTICLES := $(wildcard org/*.org)
ARTICLES_OBJ := $(patsubst %.org, src/%.html, $(ARTICLES))

# In MacOSX, if you want to use your own installed version of Emacs,
# modify the path below this line.
#EMACS=/Applications/Emacs.app/Contents/MacOS/Emacs
EMACS=$(shell which emacs)


all: www
rebuild: clean all

www: articles
	jekyll

articles: $(ARTICLES)
	$(EMACS) --batch --script publish.el 
	./html5tize.rb $(wildcard src/articles/*.html)

clean:
	rm -f $(ARTICLES_OBJ)
	rm -rf www

dist-clean:
	find . -name '*~' -delete
