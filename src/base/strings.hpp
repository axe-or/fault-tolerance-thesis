#pragma once
#include "base.hpp"

typedef struct {
	u8  bytes[4];
	i32 size;
} RuneEncoded;

typedef struct {
	rune codepoint;
	i32 size;
} RuneDecoded;

#define RUNE_ERROR ((rune)(0xfffd))

RuneDecoded str_decode_rune(byte const* buf, usize buflen);

RuneEncoded str_encode_rune(rune codepoint);

static inline
Slice<byte> raw_bytes(String s){
	return Slice<byte>{(byte*)s.data, s.len};
}

