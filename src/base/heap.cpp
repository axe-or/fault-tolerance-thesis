#include "memory.hpp"

extern "C" {
void* calloc(size_t num, size_t size);
void* realloc(void* p, size_t size);
void  free(void* p);
}

void* heap_alloc(usize nbytes){
	return calloc(nbytes, 1);
}

void* heap_realloc(void* ptr, usize new_size){
	return realloc(ptr, new_size);
}

void heap_free(void* ptr){
	free(ptr);
}

