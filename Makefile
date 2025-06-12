# LESS params
LESS_DIR = ./static/less
LESS_FILE = style.less

# CSS params
CSS_DIR = ./static/css
CSS_FILE = style.min.css
CSS_TMP_FILE = tmp.css

define build_less
	npx lessc $(LESS_DIR)/$(1) > $(CSS_DIR)/$(CSS_TMP_FILE)
	npx uglifycss $(CSS_DIR)/$(CSS_TMP_FILE) > $(CSS_DIR)/$(2)
	rm -f $(CSS_DIR)/$(CSS_TMP_FILE)
endef

.PHONY: clean demo build build-ltr prepare

build: clean prepare build-ltr

prepare:
	yarn install

build-ltr:
	$(call build_less,$(LESS_FILE),$(CSS_FILE))

demo: build
	mkdir -p demo/themes/coder-portfolio
	rsync -av exampleSite/* demo
	rsync -av --exclude='demo' --exclude='exampleSite' --exclude='.git' . demo/themes/coder-portfolio
	cd demo && hugo serve -D

clean:
	rm -f $(CSS_DIR)/*.css
	rm -rf demo
