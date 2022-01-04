#ifndef KERNEL_CUH

#define KERNEL_CUH
#include <omp.h>

double getValue(int M, int N, int x_row, int y_col, double* List);

int getRowInd(int M, int N, int Ind);

int getColInd(int M, int N, int Ind);

void getMulti(int M, int N, int K, int ind, double* A, double* B, double* C);

void Kernel(int M, int N, int K, double* A, double* B, double* C);

#endif