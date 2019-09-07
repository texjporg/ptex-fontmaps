DOCTARGET = kanji-config-updmap
PDFTARGET = $(addsuffix .pdf,$(DOCTARGET))
DVITARGET = $(addsuffix .dvi,$(DOCTARGET))
KANJI = -kanji=utf8
FONTMAP = -f ipaex.map -f ptex-ipaex.map
TEXMF = $(shell kpsewhich -var-value=TEXMFHOME)

default: $(DVITARGET) maptarget
all: $(PDFTARGET) maptarget

.SUFFIXES: .tex .dvi .pdf
.tex.dvi:
	platex $(KANJI) $<
	platex $(KANJI) $<
	platex $(KANJI) $<
	rm -f *.aux *.log *.toc
.dvi.pdf:
	dvipdfmx $(FONTMAP) $<

.PHONY: maptarget install clean
maptarget:
	if [ ! -d maps ]; then mkdir maps; fi
	cd maps; texlua ../tools/mkmap-ja.lua
	cd maps; texlua ../tools/mkmap-ko.lua
	cd maps; texlua ../tools/mkmap-sc.lua
	cd maps; texlua ../tools/mkmap-tc.lua
	cd maps; texlua ../tools/mkmap-ai0-ja.lua
	cd maps; texlua ../tools/mkmap-ai0-ko.lua
	cd maps; texlua ../tools/mkmap-ai0-sc.lua
	cd maps; texlua ../tools/mkmap-ai0-tc.lua
install:
	mkdir -p ${TEXMF}/doc/fonts/ptex-fontmaps
	cp ./README ${TEXMF}/doc/fonts/ptex-fontmaps/
	cp ./*.tex ${TEXMF}/doc/fonts/ptex-fontmaps/
	cp ./*.pdf ${TEXMF}/doc/fonts/ptex-fontmaps/
	mkdir -p ${TEXMF}/fonts/cmap/ptex-fontmaps
	cp cmap/* ${TEXMF}/fonts/cmap/ptex-fontmaps/
	mkdir -p ${TEXMF}/fonts/map/dvipdfmx/ptex-fontmaps
	cp -r maps ${TEXMF}/fonts/map/dvipdfmx/ptex-fontmaps/
	mkdir -p ${TEXMF}/fonts/misc/ptex-fontmaps
	cp database/*.dat ${TEXMF}/fonts/misc/ptex-fontmaps/
	mkdir -p ${TEXMF}/scripts/ptex-fontmaps
	ls script/* | grep -v updmap-otf.sh | xargs -I % cp % ${TEXMF}/scripts/ptex-fontmaps/
	mkdir -p ${TEXMF}/source/ptex-fontmaps/script
	cp script/updmap-otf.sh ${TEXMF}/source/ptex-fontmaps/script
	mkdir -p ${TEXMF}/source/ptex-fontmaps/tools
	cp tools/* ${TEXMF}/source/ptex-fontmaps/tools/
clean:
	rm -f $(DVITARGET) $(PDFTARGET)
	if [ -d maps ]; then cd maps; rm -rf *; fi
