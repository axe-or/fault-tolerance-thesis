#pragma once
#include "build_context.hpp"

// Essential definitions
#include <stdint.h>
#include <stddef.h>
#include <stdalign.h>
#include <stdarg.h>
#include <stdbool.h>
#include <atomic>

template<typename T> constexpr
T max(T a, T b){
	return a > b ? a : b;
}

template<typename T> constexpr
T min(T a, T b){
	return a > b ? a : b;
}

template<typename T> constexpr
T clamp(T lo, T x, T hi){
	return min(max(lo, x), hi);
}

#if defined(compiler_vendor_clang) || defined(compiler_vendor_gcc)
	#define attribute_force_inline __attribute__((always_inline))
#elif defined(compiler_vendor_msvc)
	#define attribute_force_inline __forceinline
#else
	#define attribute_force_inline
#endif

#if defined(compiler_vendor_clang) || defined(compiler_vendor_gcc) || defined(compiler_vendor_tcc) || defined(compiler_vendor_msvc)
	#define typeof(X) __typeof__(X)
#else
	#error "typeof not defined"
#endif

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
using byte    = uint8_t;
using rune    = int32_t;

using f32 = float;
using f64 = double;

static_assert(
	(sizeof(isize) == sizeof(usize)) &&
	(sizeof(void*) == sizeof(void (*)(void))) &&
	(sizeof(void*) == sizeof(uintptr)),
 "Size symmetry misatch");

#define panic(Msg) panic_ex((Msg), __FILE__, __LINE__)

#define ensure(Pred, Msg) ensure_ex((Pred), (Msg), __FILE__, __LINE__)

#if defined(build_type_release)
	#define debug_ensure(Pred, Msg)
#else
	#define debug_ensure(Pred, Msg) ensure_ex((Pred), (Msg), __FILE__, __LINE__)
#endif

// TODO: remove hosted impl
extern "C" {
	int printf(char const*, ...) noexcept;
	[[noreturn]] void abort() noexcept;
}

static inline
void ensure_ex(bool predicate, char const* msg, char const* file, i32 line){
	if(!predicate){
		printf("(%s:%d) Assertion failed: %s\n", file, line, msg);
		abort();
	}
}

[[noreturn]] static inline
void panic_ex(char const* msg, char const* file, i32 line){
	printf("(%s:%d) Panic: %s\n", file, line, msg);
	abort();
}

template<typename T>
struct Slice {
	T*    data;
	usize len;

	T& operator[](usize idx){
		ensure(idx < len, "Index to slice is out of bounds");
		return data[idx];
	}

	T const& operator[](usize idx) const{
		ensure(idx < len, "Index to slice is out of bounds");
		return data[idx];
	}
};

template<typename T>
Slice<T> slice(Slice<T> s, usize begin, usize end){
	ensure(end <= s.len && begin <= end, "Invalid slice range");
	return Slice<T>(&s.data[begin], end - begin);
}

template<typename T>
Slice<T> skip(Slice<T> s, usize n){
	ensure(n < s.len, "Invalid skip count");
	return Slice<T>(&s.data[n], s.len - n);
}

template<typename T>
Slice<T> take(Slice<T> s, usize n){
	ensure(n < s.len, "Invalid take count");
	return Slice<T>(s.data, n);
}

// Primitive string support
static inline
usize cstring_len(char const* cs){
	usize n = 0;
	while(cs[n] != 0){
		n += 1;
	}
	return n;
}

struct String {
	char const* data;
	usize len;

	byte operator[](usize idx) const {
		ensure(idx < len, "Out of bounds access to string");
		return data[idx];
	}

	String() : data{nullptr}, len{0} {}
	String(char const* b, usize n) : data{b}, len{n} {}
	String(char const* cs) : data{cs}, len{cstring_len(cs)} {}
};

#define str_fmt(S) ((int)((S).len)), ((char const*)((S).data))

static inline
Slice<u8> raw_data(String s){
	return Slice<u8>{.data = (u8*)s.data, .len = s.len};
}

static inline
String slice(String s, usize begin, usize end){
	ensure(end <= s.len && begin <= end, "Invalid slice range");
	return String(&s.data[begin], end - begin);
}

static inline
String skip(String s, usize n){
	ensure(n < s.len, "Invalid skip count");
	return String(&s.data[n], s.len - n);
}

static inline
String take(String s, usize n){
	ensure(n < s.len, "Invalid take count");
	return String(s.data, n);
}


template<typename T>
Slice<T> make_slice(usize n){
	T* p = new T[n];
	if(!p){
		return Slice<T>{nullptr, 0};
	}
	return Slice<T>{p, n};
}

template<typename T>
using Atomic = std::atomic<T>;

using std::atomic_load;
using std::atomic_store;
using std::atomic_load_explicit;
using std::atomic_store_explicit;

