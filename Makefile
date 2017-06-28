TEXMF = $(shell kpsewhich -var-value=TEXMFHOME)

.PHONY: all clean
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
clean:
	if [ -d maps ]; then cd maps; rm -rf *; fi
