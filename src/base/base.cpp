#include "strings.cpp"
#include "memory.cpp"
#include "heap.cpp"
#include "arena.cpp"

/// Platform specific code
#if defined(operating_system_linux)
	#include "virtual_linux.cpp"
	#include "thread_linux.cpp"
	#include "files_linux.cpp"
#elif defined(operating_system_windows)
	#include "virtual_windows.cpp"
	#include "thread_windows.cpp"
	#include "files_windows.cpp"
#endif

