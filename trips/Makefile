# $Id$

GENTHUMB=./browse.cgi

clean:
	find . -path '*.thumbnails' -exec rm -rf {} \;
	find . -path '*.xvpics' -exec rm -rf {} \;

all:
	$(GENTHUMB)

rebuild: clean all

upload: all
	ssh $(REMOTE_USR)@$(REMOTE_HOST) "cd $(REMOTE_PREFIX); mkdir -p trips;"
	find . -path '*CVS' -prune -o \( -iname '*.html' -o -iname '*.cgi' \
		-iname '*.jpg' -o -iname '*.png' \) \
		-print | \
	xargs tar -cf - | ssh -C $(REMOTE_USR)@$(REMOTE_HOST) \
		"cd $(REMOTE_PREFIX)/trips; tar -xf -"

