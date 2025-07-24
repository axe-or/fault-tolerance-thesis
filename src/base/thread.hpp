#pragma once

#include "base.hpp"
#include "memory.hpp"


enum ThreadState : u32{
	Thread_Undefined   = 0,
	Thread_Initialized = 1,
	Thread_Started     = 2,
	Thread_Done        = 3,
	Thread__COUNT,
};

struct Thread;

using ThreadFunc = void (*)(Thread*);

struct Thread {
	void* arg;
	void* result;
	ThreadFunc func;
	Atomic<ThreadState> state;
	Arena temp_arena;

	void* _internal;
};

Thread* thread_create(ThreadFunc func, void* arg);

void thread_start(Thread* thr);

void thread_destroy(Thread* thr);

void thread_join(Thread* thr);

