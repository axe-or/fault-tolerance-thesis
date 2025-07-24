#include "base/base.hpp"
#include <cstdio>

String crc32_build_lut(u32 poly){
	auto buf = make<char>(256 * 16);

	usize cur = 0;
	for(u32 i = 0; i < 256; i++) {
		u32 ch = i;
		u32 crc = 0;
		for(usize j = 0; j < 8; j++) {
			u32 b = (ch ^ crc) & 1;
			crc >>= 1;
			if(b){
				crc = crc ^ poly;
			}
			ch >>= 1;
		}

		cur += snprintf(&buf.data[cur], buf.len - cur, "0x%08x,", crc);
	}

	return String(buf.data, cur);
}

void file_write_text(char const* path, String data){
	FILE* f = fopen(path, "wb");
	ensure(f != NULL, "Failed to open file");
	usize written = fwrite(data.data, 1, data.len, f);
	ensure(written == data.len, "Partial write");
	fclose(f);
}

int main(){
	constexpr u32 crc32_poly = 0xedb88320; // TODO: Move into header
	String crc_lut = crc32_build_lut(crc32_poly);
	file_write_text("generated/crc32_lut.c", crc_lut);
}

