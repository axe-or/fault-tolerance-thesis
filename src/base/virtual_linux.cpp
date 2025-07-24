#include "memory.hpp"

#include <sys/mman.h>

void* virtual_reserve(usize nbytes){
	void* addr = mmap(NULL, nbytes, MemoryProtection_None, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	return addr;
}

void virtual_release(void* p, usize nbytes){
	munmap(p, nbytes);
}

bool virtual_commit(void* p, usize nbytes){
	return mprotect(p, nbytes, PROT_READ | PROT_WRITE) == 0;
}

void virtual_decommit(void *p, usize nbytes){
	mprotect(p, nbytes, PROT_NONE);
	madvise(p, nbytes, MADV_FREE);
}

bool virtual_protect(void* p, usize nbytes, MemoryProtection prot){
	int flags = 0;

	if(prot & MemoryProtection_Read){
		flags |= PROT_READ;
	}
	if(prot & MemoryProtection_Write){
		flags |= PROT_WRITE;
	}
	if(prot & MemoryProtection_Execute){
		flags |= PROT_EXEC;
	}

	return mprotect(p, nbytes, flags) == 0;
}

