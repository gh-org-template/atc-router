export SHELL:=/bin/bash

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

CARGO := $(HOME)/.cargo/bin/cargo
TARGET ?= x86_64-unknown-linux-gnu

.PHONY: all test install build clean

all: ;

build: target/release/libatc_router.so target/release/libatc_router.a

target/release/libatc_router.%: src/*.rs
	$(CARGO) build --release --target $(TARGET)

install:
	$(INSTALL) -d $(DESTDIR)$(LUA_LIB_DIR)/resty/router/
	$(INSTALL) -m 664 lib/resty/router/*.lua $(DESTDIR)$(LUA_LIB_DIR)/resty/router/
	$(INSTALL) -m 775 target/*/release/libatc_router.$(SHLIB_EXT) $(DESTDIR)$(LUA_LIB_DIR)/libatc_router.so

clean:
	rm -rf target

clean/submodules:
	-git submodule foreach --recursive git reset --hard
	-git submodule update --init --recursive
	-git submodule status
