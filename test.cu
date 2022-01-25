#include <stdio.h>


int main (){


	int count;

	cudaDeviceProp prop;

	cudaGetDeviceCount(&count);

	for(int i = 0; i < count; i++){
		cudaGetDeviceProperties(&prop, i);
		printf("%s \n",prop.name);
	}

	// 그래픽 카드 모델명 출력 확인.
	
}