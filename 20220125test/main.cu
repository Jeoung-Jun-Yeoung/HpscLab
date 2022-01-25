#include <stdio.h>
#include <stdlib.h>

#include "kernel.cuh"

int main() {

	cudaSetDevice(0);

	int M, N, K;
	M = N = 3;
	K = 1;

	double *A, *B, *C , *d_A, *d_B, *d_C;

	A = (double*)malloc(sizeof(double) * M * N);
	B = (double*)malloc(sizeof(double) * N * K);
	C = (double*)malloc(sizeof(double) * M * K);

	cudaMalloc(&d_A, sizeof(double) * M * N);
	cudaMalloc(&d_B, sizeof(double) * N * K);
	cudaMalloc(&d_C, sizeof(double) * M * K);


	for (int i = 0; i < M * N; i++) {
		A[i] = 1.;
	}
	for (int i = 0; i < N * K; i++) {
		B[i] = 1.;
	}
	for (int i = 0; i < M * K; i++) {
		C[i] = 1.;
	}

	cudaMemcpy(d_A, A, sizeof(double) * M * N, cudaMemcpyHostToDevice);
	cudaMemcpy(d_B, B, sizeof(double) * N * K, cudaMemcpyHostToDevice);
	cudaMemcpy(d_C, C, sizeof(double) * M * K, cudaMemcpyHostToDevice);


	cudaDeviceProp devProp;

	cudaGetDeviceProperties(&devProp, 0);
	int nThreads = (int)(devProp.maxThreadsPerBlock / 4);

	printf("nthread %d\n",nThreads);
	//최대로 쓰나 4개를 쓰나 비슷하다.
	int nBlocks = 65535;
	printf("nBlocks %d\n",nBlocks);
	//관행

	int ind = 0;

	printf("be\n");
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

	Kernel<<<nBlocks, nThreads>>> (M, N, K, d_A, d_B, d_C);

	cudaMemcpy(C, d_C, sizeof(double) * M * K, cudaMemcpyDeviceToHost);



	ind = 0;

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

	cudaFree(d_A);
	cudaFree(d_B);
	cudaFree(d_C);

	free(A);
	free(B);
	free(C);

	return 0;
}