#include "basic.hpp"

// TODO: Stop using iostream, it's insanely memory heavy and convoluted for
//       what it offers, use stb_sprintf with a fixed sized buffer.
#include <iostream>
template<typename T>
void print(T x){
	std::cout << x << '\n';
}
template<typename T, typename ...Rest>
void print(T x, Rest&& ...rest){
	std::cout << x << ' ';
	print(rest...);
}

template<typename T>
std::ostream& operator<<(std::ostream& os, Slice<T> s){
	os << "[ ";
	for(usize i = 0; i < s.len(); i += 1){
		os << s[i] << ' ';
	}
	os << "]";
	return os;
}

int main(){
	auto s = slice_make<u64>(5).fill(69).take(3);
	print(5, 6, "Hello", s, 8);
}
