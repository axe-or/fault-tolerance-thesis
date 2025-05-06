#pragma once
#include "build_context.h"

#include <stdint.h>
#include <stddef.h>
#include <stdalign.h>

using i8  = int8_t;
using i16 = int16_t;
using i32 = int32_t;
using i64 = int64_t;

using u8  = uint8_t;
using u16 = uint16_t;
using u32 = uint32_t;
using u64 = uint64_t;

using isize   = ptrdiff_t;
using usize   = size_t;
using uintptr = uintptr_t;

static_assert(sizeof(isize) == sizeof(usize), "Mismatched size types");
static_assert(sizeof(void*) == sizeof( void*(*)(void*)), "Mismatched function/data pointers");

//// Helpers
#if defined(COMPILER_MSVC)
	#define force_inline __forceinline
#elif defined(COMPILER_CLANG) || defined(COMPILER_GCC)
	#define force_inline __attribute__((always_inline)) inline
#else
	#warning "Could not find compiler's force_inline attribute"
	#define force_inline
#endif

template<typename T>
constexpr static inline
T min(T const& a, T const& b){
	return a < b ? a : b;
}

template<typename T>
constexpr static inline
T max(T const& a, T const& b){
	return a < b ? a : b;
}

//// Assertions
[[noreturn]] static inline
void trap(){
	#if defined(COMPILER_MSVC)
	__debugbreak();
	#else
	__builtin_trap();
	#endif
}

extern "C" { int printf(char const*, ...); }

static inline
void ensure_ex(bool predicate, char const* msg, char const* file, int line){
	if(!predicate){
		printf("(%s:%d) Assertion failed: %s\n", file, line, msg);
		trap();
	}
}

[[noreturn]] static inline
void panic_ex(char const* msg, char const* file, int line){
	printf("(%s:%d) Panic: %s\n", file, line, msg);
	trap();
}

[[noreturn]] static inline
void unimplemented_ex(char const* msg, char const* file, int line){
	printf("(%s:%d) Unimplemented: %s\n", file, line, msg);
	trap();
}

static inline
void bounds_check_ex(bool predicate, char const* msg, char const* file, int line){
	if(!predicate){
		printf("(%s:%d) Bounds check error: %s\n", file, line, msg);
		trap();
	}
}

#define panic(Msg) panic_ex((Msg), __FILE__, __LINE__)

#ifndef DISABLE_ASSERTS
	#define ensure(Pred, Msg) ensure_ex((Pred), (Msg), __FILE__, __LINE__)
	#define unimplemented(Msg) unimplemented_ex((Msg), __FILE__, __LINE__)
#else
	#define ensure(Pred, Msg)
	#define unimplemented(Msg)
#endif

#ifndef DISABLE_BOUNDS_CHECK
	#define bounds_check(Pred, Msg) bounds_check_ex((Pred), (Msg), __FILE__, __LINE__)
#else
	#define bounds_check(Pred, Msg)
#endif

//// Defer
namespace defer_detail {
    template<typename F>
    struct deferred_call {
        F f;
        force_inline constexpr deferred_call(F&& f) noexcept : f{static_cast<F&&>(f)}  {}
        force_inline ~deferred_call() noexcept { f(); }
    };

    template<typename F> static force_inline 
    auto make_deferred_call(F&& f){
        return deferred_call<F>(static_cast<F&&>(f));
    }

    #define defer_detail_glue0(X, Y) X##Y
    #define defer_detail_glue1(X, Y) defer_detail_glue0(X, Y)
    #define defer_detail_glue_counter(X) defer_detail_glue1(X, __COUNTER__)
    #define defer(Stmt) auto defer_detail_glue_counter(_deferred_) = ::defer_detail::make_deferred_call([&]() force_inline { Stmt ; })
}

//// Slice
template<typename T>
struct Slice {
	T* _data;
	usize _length;

	Slice<T> fill(T const& v){
		for(usize i = 0; i < _length; i += 1){
			_data[i] = v;
		}
		return *this;
	}

	T& operator[](usize idx){
		bounds_check(idx < _length, "Out of bounds index");
		return _data[idx];
	}

	T const& operator[](usize idx) const {
		bounds_check(idx < _length, "Out of bounds index");
		return _data[idx];
	}

	Slice<T> take(usize n){
		bounds_check(n <= _length, "Cannot take beyond slice");
		return Slice(_data, n);
	}

	Slice<T> skip(usize n){
		bounds_check(n <= _length, "Cannot skip beyond slice");
		return Slice(_data + n, _length - n);
	}

	Slice<T> slice(usize start, usize end){
		bounds_check(end >= start && end <= _length, "Improper slice range");
		return Slice(_data + start, _length - end);
	}

	constexpr Slice() : _data{nullptr}, _length{0} {}
	constexpr Slice(T* p, usize n) : _data{p}, _length{n} {}

	constexpr force_inline auto len() const { return _length; }
	constexpr force_inline auto raw_data() const { return _data; }
	constexpr force_inline auto empty() const { return _length == 0 || _data == nullptr; }
};

template<typename T>
void slice_copy(Slice<T> dest, Slice<T> src){
	usize n = min(dest.len(), src.len());
	for(usize i = 0; i < n; i += 1){
		dest._data[i] = src._data[i];
	}
}

template<typename T, usize N>
struct Array {
	T _data[N];

	Slice<T> slice(){
		return Slice(&_data[0], N);
	}

	Slice<T> slice(usize start, usize end){
		bounds_check(end >= start && end <= _length, "Improper slice range");
		return Slice(&_data[0] + start, N - end);
	}

	T& operator[](usize idx){
		bounds_check(idx < _length, "Out of bounds index");
		return _data[idx];
	}

	T const& operator[](usize idx) const {
		bounds_check(idx < _length, "Out of bounds index");
		return _data[idx];
	}

	constexpr force_inline auto len() const { return N; }
	constexpr force_inline auto raw_data() const { return &_data[0]; }
};

