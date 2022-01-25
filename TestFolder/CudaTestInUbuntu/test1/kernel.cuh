#ifndef KERNEL_CUH
#define KERNEL_CUH
#include <omp.h>
#include <cuda.h>

__host__ __device__
double getValue(int M, int N, int x_row, int y_col, double* List);

__host__ __device__
int getRowInd(int M, int N, int Ind);

__host__ __device__
int getColInd(int M, int N, int Ind);

__host__ __device__
void getMulti(int M, int N, int K, int ind, double* A, double* B, double* C);

__global__
void Kernel(int M, int N, int K, double* A, double* B, double* C);

#endif