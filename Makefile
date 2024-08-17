OS=$(shell uname -s)

ifeq ($(OS), Darwin)
SHLIB_EXT=dylib
else
SHLIB_EXT=so
endif

OPENRESTY_PREFIX=/usr/local/openresty

#LUA_VERSION := 5.1
PREFIX ?=          /usr/local
LUA_INCLUDE_DIR ?= $(PREFIX)/include
LUA_LIB_DIR ?=     $(PREFIX)/lib/lua/$(LUA_VERSION)
INSTALL ?= install

.PHONY: all test install build clean

all: ;

build: atc-router/target/release/libatc_router.$(SHLIB_EXT) atc-router/target/release/libatc_router.a

atc-router/target/release/libatc_router.%: atc-router/src/*.rs
	cd atc-router && cargo build --release

install: build
	$(INSTALL) -d $(DESTDIR)$(LUA_LIB_DIR)/resty/router/
	$(INSTALL) -m 664 atc-router/lib/resty/router/*.lua $(DESTDIR)$(LUA_LIB_DIR)/resty/router/
	$(INSTALL) -m 775 atc-router/target/release/libatc_router.$(SHLIB_EXT) $(DESTDIR)$(LUA_LIB_DIR)/libatc_router.$(SHLIB_EXT)

clean:
	rm -rf atc-router/target
