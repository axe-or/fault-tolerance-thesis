#pragma once

#include "base.hpp"

void* mem_copy(void* dest, void const* src, isize n);

void* mem_copy_no_overlap(void* dest, void const* src, isize n);

void* mem_set(void* dest, byte v, isize n);

isize mem_compare(void const* lhs, void const* rhs, isize n);

static inline
bool mem_valid_alignment(usize align){
	return align && ((align & (align - 1)) == 0);
}

static inline
uintptr mem_align_forward_ptr(uintptr p, uintptr a){
	ensure(mem_valid_alignment(a), "Alignment must be a power of 2 greater than 0");
	uintptr mod = p & (a - 1); /* Fast modulo for powers of 2 */
	if(mod > 0){
		p += (a - mod);
	}
	return p;
}

enum MemoryProtection : u32 {
	MemoryProtection_None    = 0,
	MemoryProtection_Read    = (1 << 1),
	MemoryProtection_Write   = (1 << 2),
	MemoryProtection_Execute = (1 << 3),
};

void virtual_release(void* p, usize nbytes);

bool virtual_commit(void* p, usize nbytes);

void virtual_decommit(void *p, usize nbytes);

bool virtual_protect(void* p, usize nbytes, MemoryProtection prot);

void* heap_alloc(usize nbytes);

void* heap_realloc(void* ptr, usize new_size);

void heap_free(void* ptr);

struct MemoryLayout {
	usize size;
	usize align;
};

template<typename T>
constexpr MemoryLayout mem_layout_of = {
	.size = sizeof(T),
	.align = alignof(T),
};

enum AllocatorMode : u8 {
	AllocatorMode_Alloc,
	AllocatorMode_Realloc,
	AllocatorMode_Free,
	AllocatorMode_FreeAll,
};

using AllocatorFunc = uintptr (*)(
	void* _data,
	AllocatorMode mode,
	void* old_ptr,
	usize old_size,
	usize new_size,
	usize align
);

struct Allocator {
	AllocatorFunc func;
	void*         data;
};

constexpr usize mem_default_alignment = alignof(max_align_t);

void* mem_alloc(Allocator a, usize size, usize align);

void* mem_realloc(Allocator a, void* p, usize old_size, usize new_size, usize align);

void mem_free(Allocator a, void* p, usize size, usize align);

void mem_free_all(Allocator a);

template<typename T>
T* make(Allocator a){
	return (T*)mem_alloc(a, sizeof(T), alignof(T));
}

template<typename T>
Slice<T> make_slice(usize n, Allocator a){
	auto p = (T*)mem_alloc(a, sizeof(T) * n, alignof(T));
	if(!p){ return { nullptr, 0 }; }
	return Slice<T>{p, n};
}

template<typename T>
void destroy(T* p, Allocator a){
	return mem_free(a, p, sizeof(T), alignof(T));
}

template<typename T>
void destroy(Slice<T> s, Allocator a){
	return mem_free(a, s.data, sizeof(T) * s.len, alignof(T));
}

typedef struct Arena Arena;
typedef struct ArenaRegion ArenaRegion;

struct Arena {
	void* data;
	usize capacity;
	usize offset;
	void* last_allocation;
	u32   region_count; 
};

struct ArenaRegion {
	Arena* arena;
	usize offset;
};

Arena arena_from_buffer(Slice<byte> buf);

Arena arena_from_heap(usize capacity);

void* arena_alloc(Arena* arena, usize size, usize align);

bool arena_resize(Arena* arena, void* ptr, usize size);

void arena_reset(Arena* arena);

ArenaRegion arena_region_begin(Arena* a);

void arena_region_end(ArenaRegion reg);

Allocator arena_allocator(Arena* arena);

