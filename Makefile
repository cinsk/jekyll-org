
.PHONY: clean all rebuild www articles

ARTICLES := $(wildcard org/*.org)
ARTICLES_OBJ := $(patsubst %.org, src/%.html, $(ARTICLES))

# In MacOSX, if you want to use your own installed version of Emacs,
# modify the path below this line.
#EMACS=/Applications/Emacs.app/Contents/MacOS/Emacs
EMACS=$(shell which emacs)


PREFIX=/var/www/localhost/htdocs

all: cfaqs www
rebuild: clean all

cfaqs:
	cd src/cfaqs.src && $(MAKE)
	cp src/cfaqs.src/cfaqs-ko.pdf* src/cfaqs/
	cp -a src/cfaqs.src/html src/cfaqs/

www: articles
	rm -rf src/_posts/*~
	jekyll

articles: $(ARTICLES)
	$(EMACS) --batch --script publish.el 
	./html5tize.rb $(wildcard src/articles/*.html)

clean:
	rm -f src/cfaqs/cfaqs-ko.pdf*
	rm -rf src/cfaqs/html
	cd src/cfaqs.src && $(MAKE) clean
	rm -f $(ARTICLES_OBJ)
	rm -rf www
	rm -rf $$HOME/.org-timestamps/org-posts*.cache
	rm -rf $$HOME/.org-timestamps/org-www*.cache

dist-clean:
	find . -name '*~' -delete

install:
	cp -a www/.htaccess $(PREFIX)/
	cp -a www/* $(PREFIX)/
