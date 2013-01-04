ifndef REMOTE_USR
  REMOTE_USR=cinsk
  REMOTE_HOST=pcrc.hongik.ac.kr
  REMOTE_PREFIX=public_html
endif

GENTHUMB=./browse.cgi

clean:
	find . -path '*.thumbnails' -exec rm -rf {} \;
	find . -path '*.xvpics' -exec rm -rf {} \;
	find . -path '*~' -exec rm -f {} \;

all:
	$(GENTHUMB)

rebuild: clean all

upload: all
	find . -path '*CVS' -prune -o \( -iname '*.html*' -o -iname '*cgi' \) \
		-exec scp \{\} $(REMOTE_USR)@$(REMOTE_HOST):$(REMOTE_PREFIX)/trips/\{\} \;
	#ssh $(REMOTE_USR)@$(REMOTE_HOST) "cd $(REMOTE_PREFIX); mkdir -p trips;"
	#find . -path '*CVS' -prune -o \( -iname '*.html' -o -iname '*.cgi' \
		-iname '*.jpg' -o -iname '*.png' \) \
		-print | \
	xargs tar -cf - | ssh -C $(REMOTE_USR)@$(REMOTE_HOST) \
		"cd $(REMOTE_PREFIX)/trips; tar -xf -"

