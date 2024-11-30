#include <iostream>
#include <chrono>
int main() {

	std::chrono::time_point<std::chrono::system_clock> start, end;

	start = std::chrono::system_clock::now();

	int n = 1000;
	int* a = new int[n];
	int* b = new int[n];
	int* c = new int[n];

	for (int i = 0; i < n; i++)
		c[i] = a[i] + b[i];

	end = std::chrono::system_clock::now();
	std::chrono::duration<double> elapsed_seconds = end - start;
	std::cout << elapsed_seconds.count() << " sec\n";
}