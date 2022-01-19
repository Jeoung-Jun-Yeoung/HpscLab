#include <iostream>
#include "book.h"

__global__ void add(int a, int b, int* c){
	*c = a + b;
}

int main(void){

	int c;
	
	int* a;
	int* b;

	int *dev_c = (int*)malloc(sizeof(int));

	a = (int*)malloc(sizeof(int));
	b = (int*)malloc(sizeof(int));
	
	cudaMalloc( &dev_c, sizeof(int));

	add<<<1,1>>>(2, 7, dev_c);

	cudaMemcpy(&c,dev_c,sizeof(int),cudaMemcpyDeviceToHost);

	printf("2 + 7 = %d\n",c);
	
	cudaFree(dev_c);

	return 0;
}