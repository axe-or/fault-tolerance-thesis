#include "files.hpp"
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>

Slice<u8> file_read(Allocator a, String path){
	constexpr usize tmp_path_len = 4096;
	thread_local char tmp_path[tmp_path_len];

	mem_copy_no_overlap(tmp_path, path.data, min(path.len, tmp_path_len - 1));
	tmp_path[tmp_path_len - 1] = 0;

	int fd = open(&tmp_path[0], O_RDONLY);
	if(fd < 0){
		return {};
	}
	defer(close(fd));

	struct stat status = {};
	if(fstat(fd, &status) != 0){
		return {};
	}

	if(!S_ISREG(status.st_mode)){
		return {};
	}

	usize file_size = status.st_size;

	u8* file_data = (u8*)mem_alloc(a, file_size, mem_default_alignment);
	if(!file_data){
		return {};
	}

	if(read(fd, file_data, file_size) < 0){
		mem_free(a, file_data, file_size, mem_default_alignment);
		return {};
	}

	return Slice<u8>{.data = file_data, .len = file_size};
}

// i64 file_write(Allocator a, String path, Slice<u8> data){}

