#include <stdio.h>


int main (){
	int c;
	int *dev_c;

	cudaMalloc((void**)&dev_c, sizeof(int));


	add<<<1,1>>>(2,10,dev_c);

	cudaMemcpy(&c,dev_c,sizeof(int),cudaMemcpyDeviceToHost);

	printf("2 + 7 = %d\n",c);

	int count;

	cudaDeviceProp

	cudaGetDeviceCount(&count);



	cudaFree(dev_c);
	
}