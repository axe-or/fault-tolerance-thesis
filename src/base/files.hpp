#pragma once
#include "base.hpp"
#include "memory.hpp"

// enum FileType : u8 {
// 	FileType_Unknown = 0,
// 	FileType_Regular,
// 	FileType_Directory,
// };
//
// struct FileInfo {
// 	String   path;
// 	i64      size;
// 	FileType type;
// };
//
// FileInfo file_info_load(Allocator a, String path);
//
// void file_info_destroy(Allocator a, String path);

Slice<u8> file_read(Allocator a, String path);

i64 file_write(Allocator a, String path, Slice<u8> data);

