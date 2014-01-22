/*
 * Copyright (c) 2008, 2009, 2010, 2011, 2012, 2013, 2014
 *   Jonathan Schleifer <js@webkeks.org>
 *
 * All rights reserved.
 *
 * This file is part of ObjFW. It may be distributed under the terms of the
 * Q Public License 1.0, which can be found in the file LICENSE.QPL included in
 * the packaging of this file.
 *
 * Alternatively, it may be distributed under the terms of the GNU General
 * Public License, either version 2 or 3, which can be found in the file
 * LICENSE.GPLv2 or LICENSE.GPLv3 respectively included in the packaging of this
 * file.
 */

#import "objfw-defs.h"

#if !defined(OF_HAVE_THREADS) || \
    (!defined(OF_HAVE_PTHREADS) && !defined(_WIN32))
# error No threads available!
#endif

#include <math.h>

#import "OFObject.h"

#import "macros.h"

#if defined(OF_HAVE_PTHREADS)
# include <pthread.h>
typedef pthread_t of_thread_t;
typedef pthread_key_t of_tlskey_t;
typedef pthread_mutex_t of_mutex_t;
typedef pthread_cond_t of_condition_t;
#elif defined(_WIN32)
# include <windows.h>
typedef HANDLE of_thread_t;
typedef DWORD of_tlskey_t;
typedef CRITICAL_SECTION of_mutex_t;
typedef struct {
	HANDLE event;
	int count;
} of_condition_t;
#endif

#if defined(OF_HAVE_ATOMIC_OPS)
# import "atomic.h"
typedef volatile int of_spinlock_t;
# define OF_SPINCOUNT 10
#elif defined(OF_HAVE_PTHREAD_SPINLOCKS)
typedef pthread_spinlock_t of_spinlock_t;
#else
typedef of_mutex_t of_spinlock_t;
#endif

#ifdef OF_HAVE_RECURSIVE_PTHREAD_MUTEXES
# define of_rmutex_t of_mutex_t
#else
typedef struct {
	of_mutex_t mutex;
	of_tlskey_t count;
} of_rmutex_t;
#endif

#if defined(OF_HAVE_PTHREADS)
# define of_thread_is_current(t) pthread_equal(t, pthread_self())
# define of_thread_current pthread_self
#elif defined(_WIN32)
# define of_thread_is_current(t) (t == GetCurrentThread())
# define of_thread_current GetCurrentThread
#endif

static OF_INLINE bool
of_thread_new(of_thread_t *thread, id (*function)(id), id data)
{
#if defined(OF_HAVE_PTHREADS)
	return !pthread_create(thread, NULL, (void*(*)(void*))function,
	    (__bridge void*)data);
#elif defined(_WIN32)
	*thread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)function,
	    (__bridge void*)data, 0, NULL);

	return (thread != NULL);
#endif
}

static OF_INLINE bool
of_thread_join(of_thread_t thread)
{
#if defined(OF_HAVE_PTHREADS)
	void *ret;

	if (pthread_join(thread, &ret))
		return false;

# ifdef PTHREAD_CANCELED
	return (ret != PTHREAD_CANCELED);
# else
	return true;
# endif
#elif defined(_WIN32)
	if (WaitForSingleObject(thread, INFINITE))
		return false;

	CloseHandle(thread);

	return true;
#endif
}

static OF_INLINE bool
of_thread_detach(of_thread_t thread)
{
#if defined(OF_HAVE_PTHREADS)
	return !pthread_detach(thread);
#elif defined(_WIN32)
	/* FIXME */
	return true;
#endif
}

static OF_INLINE void
of_thread_exit(void)
{
#if defined(OF_HAVE_PTHREADS)
	pthread_exit(NULL);
#elif defined(_WIN32)
	ExitThread(0);
#endif
}

static OF_INLINE bool
of_mutex_new(of_mutex_t *mutex)
{
#if defined(OF_HAVE_PTHREADS)
	return !pthread_mutex_init(mutex, NULL);
#elif defined(_WIN32)
	InitializeCriticalSection(mutex);
	return true;
#endif
}

static OF_INLINE bool
of_mutex_free(of_mutex_t *mutex)
{
#if defined(OF_HAVE_PTHREADS)
	return !pthread_mutex_destroy(mutex);
#elif defined(_WIN32)
	DeleteCriticalSection(mutex);
	return true;
#endif
}

static OF_INLINE bool
of_mutex_lock(of_mutex_t *mutex)
{
#if defined(OF_HAVE_PTHREADS)
	return !pthread_mutex_lock(mutex);
#elif defined(_WIN32)
	EnterCriticalSection(mutex);
	return true;
#endif
}

static OF_INLINE bool
of_mutex_trylock(of_mutex_t *mutex)
{
#if defined(OF_HAVE_PTHREADS)
	return !pthread_mutex_trylock(mutex);
#elif defined(_WIN32)
	return TryEnterCriticalSection(mutex);
#endif
}

static OF_INLINE bool
of_mutex_unlock(of_mutex_t *mutex)
{
#if defined(OF_HAVE_PTHREADS)
	return !pthread_mutex_unlock(mutex);
#elif defined(_WIN32)
	LeaveCriticalSection(mutex);
	return true;
#endif
}

static OF_INLINE bool
of_condition_new(of_condition_t *condition)
{
#if defined(OF_HAVE_PTHREADS)
	return !pthread_cond_init(condition, NULL);
#elif defined(_WIN32)
	condition->count = 0;

	if ((condition->event = CreateEvent(NULL, FALSE, 0, NULL)) == NULL)
		return false;

	return true;
#endif
}

static OF_INLINE bool
of_condition_wait(of_condition_t *condition, of_mutex_t *mutex)
{
#if defined(OF_HAVE_PTHREADS)
	return !pthread_cond_wait(condition, mutex);
#elif defined(_WIN32)
	if (!of_mutex_unlock(mutex))
		return false;

	of_atomic_inc_int(&condition->count);

	if (WaitForSingleObject(condition->event, INFINITE) != WAIT_OBJECT_0) {
		of_mutex_lock(mutex);
		return false;
	}

	of_atomic_dec_int(&condition->count);

	if (!of_mutex_lock(mutex))
		return false;

	return true;
#endif
}

static OF_INLINE bool
of_condition_timed_wait(of_condition_t *condition, of_mutex_t *mutex,
    of_time_interval_t timeout)
{
#if defined(OF_HAVE_PTHREADS)
	struct timespec ts;

	ts.tv_sec = (time_t)timeout;
	ts.tv_nsec = lrint((timeout - ts.tv_sec) * 1000000000);

	return !pthread_cond_timedwait(condition, mutex, &ts);
#elif defined(_WIN32)
	if (!of_mutex_unlock(mutex))
		return false;

	of_atomic_inc_int(&condition->count);

	if (WaitForSingleObject(condition->event,
	    timeout * 1000) != WAIT_OBJECT_0) {
		of_mutex_lock(mutex);
		return false;
	}

	of_atomic_dec_int(&condition->count);

	if (!of_mutex_lock(mutex))
		return false;

	return true;
#endif
}

static OF_INLINE bool
of_condition_signal(of_condition_t *condition)
{
#if defined(OF_HAVE_PTHREADS)
	return !pthread_cond_signal(condition);
#elif defined(_WIN32)
	return SetEvent(condition->event);
#endif
}

static OF_INLINE bool
of_condition_broadcast(of_condition_t *condition)
{
#if defined(OF_HAVE_PTHREADS)
	return !pthread_cond_broadcast(condition);
#elif defined(_WIN32)
	int i;

	for (i = 0; i < condition->count; i++)
		if (!SetEvent(condition->event))
			return false;

	return true;
#endif
}

static OF_INLINE bool
of_condition_free(of_condition_t *condition)
{
#if defined(OF_HAVE_PTHREADS)
	return !pthread_cond_destroy(condition);
#elif defined(_WIN32)
	if (condition->count)
		return false;

	return CloseHandle(condition->event);
#endif
}

static OF_INLINE bool
of_tlskey_new(of_tlskey_t *key)
{
#if defined(OF_HAVE_PTHREADS)
	return !pthread_key_create(key, NULL);
#elif defined(_WIN32)
	return ((*key = TlsAlloc()) != TLS_OUT_OF_INDEXES);
#endif
}

static OF_INLINE void*
of_tlskey_get(of_tlskey_t key)
{
#if defined(OF_HAVE_PTHREADS)
	return pthread_getspecific(key);
#elif defined(_WIN32)
	return TlsGetValue(key);
#endif
}

static OF_INLINE bool
of_tlskey_set(of_tlskey_t key, void *ptr)
{
#if defined(OF_HAVE_PTHREADS)
	return !pthread_setspecific(key, ptr);
#elif defined(_WIN32)
	return TlsSetValue(key, ptr);
#endif
}

static OF_INLINE bool
of_tlskey_free(of_tlskey_t key)
{
#if defined(OF_HAVE_PTHREADS)
	return !pthread_key_delete(key);
#elif defined(_WIN32)
	return TlsFree(key);
#endif
}

static OF_INLINE bool
of_spinlock_new(of_spinlock_t *spinlock)
{
#if defined(OF_HAVE_ATOMIC_OPS)
	*spinlock = 0;
	return true;
#elif defined(OF_HAVE_PTHREAD_SPINLOCKS)
	return !pthread_spin_init(spinlock, 0);
#else
	return of_mutex_new(spinlock);
#endif
}

static OF_INLINE bool
of_spinlock_trylock(of_spinlock_t *spinlock)
{
#if defined(OF_HAVE_ATOMIC_OPS)
	return of_atomic_cmpswap_int(spinlock, 0, 1);
#elif defined(OF_HAVE_PTHREAD_SPINLOCKS)
	return !pthread_spin_trylock(spinlock);
#else
	return of_mutex_trylock(spinlock);
#endif
}

static OF_INLINE bool
of_spinlock_lock(of_spinlock_t *spinlock)
{
#if defined(OF_HAVE_ATOMIC_OPS)
# if defined(OF_HAVE_SCHED_YIELD) || defined(_WIN32)
	int i;

	for (i = 0; i < OF_SPINCOUNT; i++)
		if (of_spinlock_trylock(spinlock))
			return true;

	while (!of_spinlock_trylock(spinlock))
#  ifndef _WIN32
		sched_yield();
#  else
		Sleep(0);
#  endif
# else
	while (!of_spinlock_trylock(spinlock));
# endif

	return true;
#elif defined(OF_HAVE_PTHREAD_SPINLOCKS)
	return !pthread_spin_lock(spinlock);
#else
	return of_mutex_lock(spinlock);
#endif
}

static OF_INLINE bool
of_spinlock_unlock(of_spinlock_t *spinlock)
{
#if defined(OF_HAVE_ATOMIC_OPS)
	return of_atomic_cmpswap_int(spinlock, 1, 0);
#elif defined(OF_HAVE_PTHREAD_SPINLOCKS)
	return !pthread_spin_unlock(spinlock);
#else
	return of_mutex_unlock(spinlock);
#endif
}

static OF_INLINE bool
of_spinlock_free(of_spinlock_t *spinlock)
{
#if defined(OF_HAVE_ATOMIC_OPS)
	return true;
#elif defined(OF_HAVE_PTHREAD_SPINLOCKS)
	return !pthread_spin_destroy(spinlock);
#else
	return of_mutex_free(spinlock);
#endif
}

#ifdef OF_HAVE_RECURSIVE_PTHREAD_MUTEXES
static OF_INLINE bool
of_rmutex_new(of_mutex_t *mutex)
{
	pthread_mutexattr_t attr;

	if (pthread_mutexattr_init(&attr))
		return false;

	if (pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE))
		return false;

	if (pthread_mutex_init(mutex, &attr))
		return false;

	if (pthread_mutexattr_destroy(&attr))
		return false;

	return true;
}

# define of_rmutex_lock of_mutex_lock
# define of_rmutex_trylock of_mutex_trylock
# define of_rmutex_unlock of_mutex_unlock
# define of_rmutex_free of_mutex_free
#else
static OF_INLINE bool
of_rmutex_new(of_rmutex_t *rmutex)
{
	if (!of_mutex_new(&rmutex->mutex))
		return false;

	if (!of_tlskey_new(&rmutex->count))
		return false;

	return true;
}

static OF_INLINE bool
of_rmutex_lock(of_rmutex_t *rmutex)
{
	uintptr_t count = (uintptr_t)of_tlskey_get(rmutex->count);

	if (count > 0) {
		if (!of_tlskey_set(rmutex->count, (void*)(count + 1)))
			return false;

		return true;
	}

	if (!of_mutex_lock(&rmutex->mutex))
		return false;

	if (!of_tlskey_set(rmutex->count, (void*)1)) {
		of_mutex_unlock(&rmutex->mutex);
		return false;
	}

	return true;
}

static OF_INLINE bool
of_rmutex_trylock(of_rmutex_t *rmutex)
{
	uintptr_t count = (uintptr_t)of_tlskey_get(rmutex->count);

	if (count > 0) {
		if (!of_tlskey_set(rmutex->count, (void*)(count + 1)))
			return false;

		return true;
	}

	if (!of_mutex_trylock(&rmutex->mutex))
		return false;

	if (!of_tlskey_set(rmutex->count, (void*)1)) {
		of_mutex_unlock(&rmutex->mutex);
		return false;
	}

	return true;
}

static OF_INLINE bool
of_rmutex_unlock(of_rmutex_t *rmutex)
{
	uintptr_t count = (uintptr_t)of_tlskey_get(rmutex->count);

	if (count > 1) {
		if (!of_tlskey_set(rmutex->count, (void*)(count - 1)))
			return false;

		return true;
	}

	if (!of_tlskey_set(rmutex->count, (void*)0))
		return false;

	if (!of_mutex_unlock(&rmutex->mutex))
		return false;

	return true;
}

static OF_INLINE bool
of_rmutex_free(of_rmutex_t *rmutex)
{
	if (!of_mutex_free(&rmutex->mutex))
		return false;

	if (!of_tlskey_free(rmutex->count))
		return false;

	return true;
}
#endif
