# Makefile for latex - ps and pdf
# Can also make html
# Works on all *.tex files in directory
RM = rm -rf
FINDANDRMAUX = rm -f `find . -type f | grep -E "(*.aux|*.bak)"`

BASE = ${wildcard *.tex}
FILES = ${BASE:%.tex=%.pdf}

LOPT =	-interaction=batchmode
LOPT2 = -shell-escape ${LOPT}

all:    pdf

%.pdf:	*.tex
	latex ${LOPT} $*
	- makeindex $*
	- bibtex $*
	latex ${LOPT} $*
	latex ${LOPT} $*
	dvips -q -Ppdf -o$*.ps $*.dvi
	ps2pdf14 $*.ps

html:	${BASE:%.tex=%}

%:	%.tex
	latex2html $*

words:	${BASE:%.tex=%}

%:	%.tex
	latex ${LOPT} $*
	dvips -q -o - $*.dvi | ps2ascii | wc -w
	@echo "words in $*"
	@echo ""

clean:
	${FINDANDRMAUX}
	${RM} ${BASE:%.tex=%.log}
	${RM} ${BASE:%.tex=%.pdf}
	${RM} ${BASE:%.tex=%.blg}
	${RM} ${BASE:%.tex=%.toc}
	${RM} ${BASE:%.tex=%.bbl}
	${RM} ${BASE:%.tex=%.aux}
	${RM} ${BASE:%.tex=%.lot}
	${RM} ${BASE:%.tex=%.lof}
	${RM} ${BASE:%.tex=%.out}

cleaner: clean
	${RM} ${BASE:%.tex=%.bbl}
	${RM} ${FILES}

htmlclean:
	${RM} ${BASE:%.tex=%/}

pdf:	${BASE:%.tex=%}

%:	%.tex
	pdflatex ${LOPT2} $*
	- bibtex $*
	pdflatex ${LOPT2} $*
	pdflatex ${LOPT2} $*

help:
	@echo Type "'make help'         To see this list"
	@echo Type "'make all'          To generate ps and pdf"
	@echo Type "'make pdf'          To generate pdf directly"
	@echo Type "'make html'         To generate html"
	@echo Type "'make clean'        To remove generated files except pdf"
	@echo Type "'make cleaner'      To remove ALL generated files"
	@echo Type "'make htmlclean'    To remove generated html files"
	@echo Type "'make words'        To get an estimate of word count"
