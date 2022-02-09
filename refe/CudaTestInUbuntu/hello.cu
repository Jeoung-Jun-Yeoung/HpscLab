#include <stdio.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <cuda.h>
#include "cuda.h"

__global__ void kernel(void){

    printf("hello\n");

}

int main (void){

    kernel <<<1,15>>>();

    return 0;
}
