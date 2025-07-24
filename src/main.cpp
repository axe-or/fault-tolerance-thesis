#include "base/base.hpp"
#include "base/strings.hpp"

constexpr u32 crc32_poly = 0xedb88320;

constexpr static u32 crc32_lut[256] = {
	#include "generated/crc32_lut.c"
};

u32 crc32(Slice<u8> bytes){
	u32 crc = 0xFFFFFFFF;

	for(usize i = 0; i < bytes.len; i++) {
		u8 ch = bytes[i];
		u32 t = (ch ^ crc) & 0xff;
		crc = (crc >> 8) ^ crc32_lut[t];
	}

	return ~ crc;
}

int main(){
	String msg = "123456789";
	printf("%08x\n", crc32(raw_bytes(msg)));
}

