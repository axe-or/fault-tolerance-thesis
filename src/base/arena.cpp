#include "memory.hpp"

Arena arena_from_buffer(Slice<byte> buf){
	return {
		.data = buf.data,
		.capacity = buf.len,
		.offset = 0,
		.last_allocation = NULL,
		.region_count = 0,
	};
}

Arena arena_from_heap(usize capacity){
	byte* buf = (byte*)heap_alloc(capacity);
	if(!buf){
		return {};
	}
	return arena_from_buffer(Slice<byte>{buf, capacity});
}

void* arena_alloc(Arena* a, usize size, usize align){
	uintptr base = (uintptr)a->data;
	uintptr current = base + (uintptr)a->offset;

	usize available = a->capacity - (current - base);

	uintptr aligned  = mem_align_forward_ptr(current, align);
	uintptr padding  = aligned - current;
	uintptr required = padding + size;

	if(required > available){
		return NULL; /* Out of memory */
	}

	a->offset += required;
	void* allocation = (void*)aligned;
	a->last_allocation = allocation;
	mem_set(allocation, 0, size);

	return allocation;
}

bool arena_resize(Arena* a, void* ptr, usize new_size){
	uintptr base    = (uintptr)a->data;
	uintptr limit   = base + a->capacity;

	ensure((uintptr)ptr >= base && (uintptr)ptr < limit, "Pointer is not owned by arena");

	if(ptr == a->last_allocation){
		uintptr last_alloc = (uintptr)a->last_allocation;
		if((last_alloc + new_size) > limit){
			return false; /* No space left */
		}

		a->offset = (last_alloc + new_size) - base;
		return true;
	}

	return false;
}

void arena_reset(Arena* arena){
	ensure(arena->region_count == 0, "Arena has dangling regions");
	arena->offset = 0;
	arena->last_allocation = NULL;
}

ArenaRegion arena_region_begin(Arena* a){
	ArenaRegion reg = {
		.arena = a,
		.offset = a->offset,
	};
	a->region_count += 1;
	return reg;
}

void arena_region_end(ArenaRegion reg){
	ensure(reg.arena->region_count > 0, "Arena has a improper region counter");
	ensure(reg.arena->offset >= reg.offset, "Arena has a lower offset than region");

	reg.arena->offset = reg.offset;
	reg.arena->region_count -= 1;
}

static
uintptr arena_allocator_func(
	void* _data,
	AllocatorMode mode,
	void* old_ptr,
	usize,
	usize new_size,
	usize align
){
	auto arena = (Arena*) _data;
	switch(mode){
	case AllocatorMode_Alloc:
		return (uintptr)arena_alloc(arena, new_size, align);

	case AllocatorMode_Realloc:
		if(arena_resize(arena, old_ptr, new_size)){
			return (uintptr)old_ptr;
		} else {
			return 0;
		}

	case AllocatorMode_Free:
		if(old_ptr){
			arena_resize(arena, old_ptr, 0);
			arena->last_allocation = nullptr;
		}
		return 0;

	case AllocatorMode_FreeAll:
		arena_reset(arena);
		return 0;
	}

	return 0;
}

Allocator arena_allocator(Arena* arena){
	return {
		.func = arena_allocator_func,
		.data = (void*)arena,
	};
}

