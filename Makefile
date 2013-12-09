include meta.mk

#LATEX=platex
LATEX=uplatex
#PANDOC=pandoc
PANDOC=~/.cabal/bin/pandoc
PANDOC_OPT=--toc --listings --chapters

NAME=zguide-ja
TEMPLATE=$(NAME).tmpl

SRCS=preface.md chapter1.md chapter2.md postface.md
MD=$(NAME).md
TEX=$(NAME).tex
DVI=$(NAME).dvi
PDF=$(NAME).pdf
EPUB=$(NAME).epub
HTML=$(NAME).html

%.dvi: %.tex
	$(LATEX) $<
	$(LATEX) $<

%.pdf: %.dvi
	dvipdfmx $^

all: $(PDF)

clean:
	rm -rf *.log *.out *.aux *.toc $(MD) $(TEX) $(DVI) $(PDF) $(EPUB) $(HTML)

$(MD): $(SRCS)
	cat $^ > $@

$(EPUB): $(MD)
	$(PANDOC) -o $@ $<

$(HTML): $(MD)
	$(PANDOC) -o $@ $<

$(TEX): $(MD) $(TEMPLATE)
	$(PANDOC) -f markdown -t latex $(PANDOC_OPT) -V version="$(VERSION)" -V pdf_title="$(PDF_TITLE)" -V pdf_subject="$(PDF_SUBJECT)" -V pdf_author="$(PDF_AUTHOR)"  -V pdf_keywords="$(PDF_KEYWORDS)" --template=$(TEMPLATE) $< | sed -e 's/Ø/{\\O}/g' -e 's/ø/{\\o}/g' > $@

$(DVI): $(TEX)

$(PDF): $(DVI)
