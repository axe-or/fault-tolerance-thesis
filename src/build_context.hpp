#pragma once
// Build context

#if defined(__clang__)
	#define compiler_vendor_clang 1
#elif defined(__TINYC__)
	#define compiler_vendor_tcc 1
#elif defined(__GNUC__)
	#define compiler_vendor_gcc 1
#elif defined(_MSC_VER)
	#define compiler_vendor_msvc 1
#else
	#error "Unknown compiler vendor"
#endif

#if defined(__linux__)
	#define operating_system_linux 1
#elif defined(_WIN32) || defined(_WIN64)
	#define operoperating_system_windows 1
#else
	#error "Unknown operating system"
#endif

static const char compiler_vendor_name[] =
#if defined(compiler_vendor_clang)
	"Clang"
#elif defined(compiler_vendor_gcc)
	"GCC"
#elif defined(compiler_vendor_tcc)
	"TCC"
#elif defined(compiler_vendor_msvc)
	"MSVC"
#endif
;

static const char operating_system_name[] =
#if defined(operating_system_linux)
	"Linux"
#elif defined(operating_system_windows)
	"Windows"
#endif
;
