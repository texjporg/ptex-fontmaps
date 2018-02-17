TEXMF = $(shell kpsewhich -var-value=TEXMFHOME)

.PHONY: all install clean
all:
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
	mkdir -p ${TEXMF}/fonts/cmap/ptex-fontmaps
	cp cmap/* ${TEXMF}/fonts/cmap/ptex-fontmaps/
	mkdir -p ${TEXMF}/fonts/map/dvipdfmx/ptex-fontmaps
	cp -r maps ${TEXMF}/fonts/map/dvipdfmx/ptex-fontmaps/
	mkdir -p ${TEXMF}/fonts/misc/$(PROJECT)
	cp database/*.dat ${TEXMF}/fonts/misc/$(PROJECT)/
	mkdir -p ${TEXMF}/scripts/ptex-fontmaps
	ls script/* | grep -v updmap-otf.sh | xargs -I % cp % ${TEXMF}/scripts/ptex-fontmaps/
	mkdir -p ${TEXMF}/source/ptex-fontmaps/script
	cp script/updmap-otf.sh ${TEXMF}/source/ptex-fontmaps/script
	mkdir -p ${TEXMF}/source/ptex-fontmaps/tools
	cp tools/* ${TEXMF}/source/ptex-fontmaps/tools/
clean:
	if [ -d maps ]; then cd maps; rm -rf *; fi
