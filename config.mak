# $Id$
# -*-makefile-*-

# The .html files and all required image files are copied to the directory,
# 
#  ${REMOTE_USR}@${REMOTE_HOST}:${REMOTE_PREFIX}
#
REMOTE_USR=cinsk
REMOTE_HOST=www.cinsk.org
REMOTE_PREFIX=public_html

# Executable pathnames
LATEX=latex
DVIPS=dvips
DVIPDFMX=dvipdfmx
GZIP=/bin/gzip
BZIP=/bin/bzip2
LATEX2HTML=latex2html

export LATEX DVIPS DVIPDFMX GZIP BZIP
export REMOTE_USR REMOTE_HOST REMOTE_PREFIX
