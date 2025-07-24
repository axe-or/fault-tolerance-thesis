#include "base.hpp"
#include "thread.hpp"
#include <pthread.h>
#include <semaphore.h>

typedef struct {
	pthread_t handle;
	sem_t     start_sema;
} ThreadLinuxInternal;

static
void* thread_linux_wrapper(void* p){
	Thread* t = (Thread*)p;
	ThreadLinuxInternal* internal = (ThreadLinuxInternal*)t->_internal;
	atomic_store(&t->state, Thread_Initialized);

	while(atomic_load(&t->state) != Thread_Started){
		sem_wait(&internal->start_sema);
	}
	t->func(t);

	atomic_store(&t->state, Thread_Done);
	return NULL;
}

void thread_start(Thread* thr){
	ensure(atomic_load(&thr->state) == Thread_Initialized, "Thread is not in an initilialized state");
	ThreadLinuxInternal* internal = (ThreadLinuxInternal*)thr->_internal;
	atomic_store(&thr->state, Thread_Started);
	sem_post(&internal->start_sema);
}

Thread* thread_create(ThreadFunc func, void* arg){
	Thread* t = (Thread*)heap_alloc(sizeof(*t));
	t->func = func;
	t->arg = arg;
	t->result = NULL;

	t->_internal = heap_alloc(sizeof(ThreadLinuxInternal));
	ThreadLinuxInternal* internal = (ThreadLinuxInternal*)t->_internal;
	bool ok = false;

	if(sem_init(&internal->start_sema, 0, 0) != 0){
		goto fail;
	}

	ok = pthread_create(&internal->handle, NULL, thread_linux_wrapper, t) == 0;

	if(!ok){
		goto fail;
	}

	return t;

fail:
	heap_free(t->_internal);
	heap_free(t);
	return NULL;
}

void thread_destroy(Thread* thr){
	ensure(atomic_load(&thr->state) == Thread_Done, "Thread is not done.");
	if(!thr){ return; }
	ThreadLinuxInternal* internal = (ThreadLinuxInternal*)thr->_internal;
	sem_destroy(&internal->start_sema);
	heap_free(thr->_internal);
	heap_free(thr);
}

void thread_join(Thread* thr){
	ensure(atomic_load(&thr->state) != Thread_Undefined, "Thread is not joinable");
	ThreadLinuxInternal* internal = (ThreadLinuxInternal*)thr->_internal;

	pthread_join(internal->handle, NULL);
}

// Thread* thread_spawn(ThreadFunc func, void* arg){
// 	ThreadLinuxWrapperArg wrapper = {
// 		.func = func,
// 		.arg = arg,
// 	};
// 	pthread_t pt;
// 	pthread_create(&pt, NULL, thread_linux_wrapper, &wrapper);
//
// 	return (Thread*)pt;
// }

