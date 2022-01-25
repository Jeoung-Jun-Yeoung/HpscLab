#include "kernel.cuh"


__host__ __device__
double getValue(int M, int N, int x_row, int y_col, double* List) {
	int Ind = x_row * N + y_col;
	return List[Ind];
}

__host__ __device__
int getRowInd(int M, int N, int Ind) {
	return (int)(Ind / N);
}

__host__ __device__
int getColInd(int M, int N, int Ind) {
	return (int)(Ind % N);
}

__host__ __device__
void getMulti(int M, int N, int K, int ind, double* A, double* B, double* C) {
	C[ind] = 0.;
	int x_row = getRowInd(M, K, ind);
	int y_col = getColInd(M, K, ind);

	for (int i = 0; i < N; i++) {
		double a = getValue(M, N, x_row, i, A);
		double b = getValue(N, K, i, y_col, B);

		C[ind] += a * b;
	}
}

__global__
void Kernel(int M, int N, int K, double* A, double* B, double* C) {

	int id = blockDim.x * blockIdx.x + threadIdx.x;
	// blockDim.x = 블럭이 갖고 있는 쓰레드 숫자.
	// blockIdx.x = 쓰레드가 몇번째 블럭에 속하는지.
	// 곱한값은 블럭의 첫번째 쓰레드가 총 쓰레드중 몇번째 스레드인지 구하고, 블럭안에서 몇번째인지 더해주면 발생된 쓰레드중 몇번째 쓰레드인지 알 수 있다.

	// gpu에서는 32, 즉 sm단위로 쓰레드 생성

	if(id < M*K) {
		getMulti(M, N, K, id, A, B, C);
	}
	// 고유의 주소값으로 각각 다른 동작을 하게 된다.
}