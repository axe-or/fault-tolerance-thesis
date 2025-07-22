#!/usr/bin/env sh

cc='clang++ -std=c++20'
cflags='-fno-strict-aliasing -fwrapv -fno-rtti -fno-exceptions'
ldflags='-fuse-ld=mold'

mode="$1"

set -eu

case "$mode" in
	"gen") $cc $cflags generate.cpp -o Gen.exe && ./Gen.exe ;;
	*) $cc $cflags main.cpp -o Test.exe && ./Test.exe ;;
esac

