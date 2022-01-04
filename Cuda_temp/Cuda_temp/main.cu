#include <stdio.h>
#include <stdlib.h>
#include "kernel.cuh"

int main() {

	int M, N, K;
	M = N = 3;
	K = 1;

	double* A, * B, * C;

	A = (double*)malloc(sizeof(double) * M * N);
	B = (double*)malloc(sizeof(double) * N * K);
	C = (double*)malloc(sizeof(double) * M * K);

	for (int i = 0; i < M * N; i++) {
		A[i] = 1.;
	}
	for (int i = 0; i < N * K; i++) {
		B[i] = 1.;
	}
	for (int i = 0; i < M * K; i++) {
		C[i] = 1.;
	}

	Kernel(M, N, K, A, B, C);
	
	int ind = 0;

	while (true)
	{
		for (int i = 0; i < K; i++) {
			printf("%f \t", C[i]);
			ind += 1;
		}
		printf("\n");
		if (M * K <= ind) {
			break;
		}
	}
	return 0;
}