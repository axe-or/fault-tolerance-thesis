#include "memory.hpp"

// Primitive memory operations
extern "C" {
void* memmove(void* dest, void const* src, size_t n);
void* memcpy(void* dest, void const* src, size_t n);
void* memset(void* dest, int v, size_t n);
int   memcmp(void const* lhs, void const* rhs, size_t n);
}

void* mem_copy(void* dest, void const* src, isize n){
	return memmove(dest, src, n);
}

void* mem_copy_no_overlap(void* dest, void const* src, isize n){
	return memcpy(dest, src, n);
}

void* mem_set(void* dest, byte v, isize n){
	return memset(dest, v, n);
}

isize mem_compare(void const* lhs, void const* rhs, isize n){
	return memcmp(lhs, rhs, n);
}

void* mem_alloc(Allocator a, usize size, usize align){
	return (void*)a.func(a.data, AllocatorMode_Alloc, nullptr, 0, size, align);
}

void* mem_realloc(Allocator a, void* p, usize old_size, usize new_size, usize align){
	return (void*)a.func(a.data, AllocatorMode_Realloc, p, old_size, new_size, align);
}

void mem_free(Allocator a, void* p, usize size, usize align){
	a.func(a.data, AllocatorMode_Free, p, size, 0, align);
}

void mem_free_all(Allocator a){
	a.func(a.data, AllocatorMode_FreeAll, nullptr, 0, 0, 0);
}
