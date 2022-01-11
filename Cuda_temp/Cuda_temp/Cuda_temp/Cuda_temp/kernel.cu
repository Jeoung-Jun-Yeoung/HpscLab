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
	// blockDim.x = ���� ���� �ִ� ������ ����.
	// blockIdx.x = �����尡 ���° ���� ���ϴ���.
	// ���Ѱ��� ���� ù��° �����尡 �� �������� ���° ���������� ���ϰ�, ���ȿ��� ���°���� �����ָ� �߻��� �������� ���° ���������� �� �� �ִ�.

	// gpu������ 32, �� sm������ ������ ����

	if(id < M*K) { 
		getMulti(M, N, K, id, A, B, C);
	}
	// ������ �ּҰ����� ���� �ٸ� ������ �ϰ� �ȴ�.
}