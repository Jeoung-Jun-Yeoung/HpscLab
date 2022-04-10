#ifndef ENCRYPT_H
#define ENCRYPT_H

#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "aeslib.hpp"

__device__ void AES_AddRoundKey(BYTE *state, BYTE *rkey) {
    for(int i = 0; i < 16; i++)
        state[i] ^= rkey[i];
}

__device__ void AES_SubBytes(BYTE *state, BYTE *gpu_Sbox) {
    for(int i = 0; i < 16; i++)
        state[i] = gpu_Sbox[state[i]];
    }
}

__device__ void AES_ShiftRows(BYTE *state) {

    BYTE tmp = state[1];
    state[1]=state[5];
    state[5]=state[9];
    state[13]=tmp;

    tmp=state[2];
    state[2]=state[10];
    state[10]=tmp;
    tmp=state[6];
    state[6]=state[14];
    state[14]=tmp;

    tmp=state[15];
    state[15]=state[11];
    state[11]=stat[7];
    state[7]=state[3];
    state[3]=tmp;

}

__device__ void AES_MixColumns(BYTE *state, BYTE gpu_Mul2) {
    
    for(int i = 0; i < 16; i += 4) {
        BYTE s0 = state[i + 0], s1 = state[i + 1];
        BYTE s2 = state[i + 2], s3 = state[i + 3];
        BYTE h = s0 ^ s1 ^ s2 ^ s3;
        // a + b + c + d 갈루아에서는 + 가 xor
        state[i + 0] ^= h ^ gpu_Mul2[s0 ^ s1];
        state[i + 1] ^= h ^ gpu_Mul2[s1 ^ s2];
        state[i + 2] ^= h ^ gpu_Mul2[s2 ^ s3];
        state[i + 3] ^= h ^ gpu_Mul2[s3 ^ s0];
        //state[i+0] = gpu_Mul2[s0]^gpu_Mul3[s1]^state[s2]^state[s3];

    }
}

__device__ void AES_Round(BYTE *state, BYTE *rkey, BYTE *gpu_Sbox, BYTE *gpu_Mul2){
    //rkey = 16 bytes
    AES_SubBytes(state, gpu_Sbox);
    AES_ShiftRow(state);
    AES_MixColumns(state, gpu_Mul2);
    AES_AddRoundKey(state, rkey)
}

__global__ void Cipher(BYTE *plaintext, int plain_length, BYTE expanded[(ROUNDS+1)*16]){
    int id = (blockDim.x*blockIdx.x+threadIdx.x);
    //sbox, expanded key load
    //len(plaintext)%16 == 0
    __shared__ BYTE gpu_Sbox[256];
    __shared__ BYTE gpu_Mul2[256];
    __shared__ BYTE gpu_expanded[16*(ROUNDS+1)];

    if(id == 0){
        for (int i=0; i<256; i++){
            gpu_Sbox[i] = Sbox[i]; 
            gpu_Mul2[i] = Mul2[i];
        }
        for (int i=0;i<16*(ROUNDS+1); i++){
            gpu_expanded[i] = expanded[i];
        }
    }
    __syncthreads();
    //encrypt
    //plantext+id*16
    if (id * 16 <= plain_length){
        //Preround
        AES_AddRoundKey(plantext+id*16, gpu_expanded);
        //Round
        //AES_Round(BYTE *state, BYTE *rkey, BYTE *gpu_Sbox, BYTE *gpu_Mul2)
        for (int r = 1; r<ROUNDS; r++){
            AES_Round(plantext+id*16, gpu_expanded+r*16, gpu_Sbox, gpu_Mul2);
        }

        //Final Round
        AES_SubBytes(plantext+id*16, gpu_Sbox);
        AES_ShiftRows(plantext+id*16);
        AES_AddRoundKey(plantext+id*16, gpu_expanded+ROUNDS*16);
    }
}

//main.cu
//Cipher <<<threads, blocks>>>(gpu_plaintext, n, gpu_expanded)

//cudaMemcpy(gpu_plaintext, plantext, n, cudaMemcpyHostToDevice);
// assert(n%16 == 0);
// plaintext == (0102030405...)*
// cudaFree(gpu_Sbox);
// cudaFree(gpu_Mul2);
// thread*Block = 100
// plaintext =1600 bytes
//(plaintext+1600*i)