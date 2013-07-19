
.PHONY: clean all rebuild www articles

ARTICLES := $(wildcard org/*.org)
ARTICLES_OBJ := $(patsubst %.org, src/%.html, $(ARTICLES))

EMACS=$(shell which emacs)

uname_S := $(shell sh -c 'uname -s 2>/dev/null || echo not')
ifeq ($(uname_S),Darwin)
  # In MacOSX, if you want to use your own installed version of Emacs,
  # modify the path below this line.
  EMACS=/Applications/Emacs.app/Contents/MacOS/Emacs
endif


PREFIX=/var/www/localhost/htdocs

all: cfaqs www
rebuild: clean all

cfaqs:
	mkdir -p src/cfaqs/
	cd src/cfaqs.src && $(MAKE)
	cp src/cfaqs.src/cfaqs-ko.pdf* src/cfaqs/
	cp -a src/cfaqs.src/html src/cfaqs/

www: articles
	rm -rf src/_posts/*~
	jekyll build

articles: $(ARTICLES)
	rm -rf $$HOME/.org-timestamps/org-posts*.cache
	rm -rf $$HOME/.org-timestamps/org-www*.cache
	$(EMACS) --batch --script publish.el 
	./html5tize.rb $(wildcard src/articles/*.html)
	./html5tize.rb $(wildcard src/_posts/*.html)

clean:
	rm -f src/cfaqs/cfaqs-ko.pdf*
	rm -rf src/cfaqs/html
	cd src/cfaqs.src && $(MAKE) clean
	rm -f $(ARTICLES_OBJ)
	rm -rf www

dist-clean:
	find . -name '*~' -delete

install:
	cp -a www/.htaccess $(PREFIX)/
	cp -a www/* $(PREFIX)/
