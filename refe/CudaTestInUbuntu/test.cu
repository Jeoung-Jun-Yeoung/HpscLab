#include <cuda_runtime.h>
#include <stdlib.h>
#include <stdio.h>
#include <cuda.h>
#include <iostream>


__global__ void kernel(int a, int b, int* c){
	*c = a + b;
}

int main(void){

	int c;
	
	int a;
	int b;

	int* dev_c;


	a = 1;

	b = 2;
	
	cudaMalloc((void**) &dev_c, sizeof(int));

	printf("asdasd c %d\n",*dev_c);

	//printf("befored c %d \n",c);

	kernel<<<1,1>>>(a, b, dev_c);

	cudaMemcpy(&c,dev_c,sizeof(int),cudaMemcpyDeviceToHost);

	printf("after c = %d\n",c);
	
	cudaFree(dev_c);

	return 0;
}
