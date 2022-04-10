#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <unistd.h>

#define BYTE unsigned char

class aes_block
{
public:
    BYTE block[16];
};

__device__ add_roundkey(){

}

__device__ sub_byte(BYTE state [], BYTE shift_bit[]){

}
__device__ shift_row(){

}
__device__ mix_column(){

}

__global__ void encrypt(){

}


int main(int argc, char* argv[]){
    FILE* plaintext_fp;

    plaintext_fp = fopen(argv[1], "rb");

    if(plaintext_fp == NULL){
        printf("the file to encypt does not exist\n");
        return 0;
    }
    // 평문이 담긴 txt 파일 오픈.

    int plaintext_size;

    fseek(plaintext_fp, 0 , SEEK_END);
    plaintext_size = ftell(plaintext_fp);

    // 평문 text size 측정.

    fseek(fp,0,SEEK_SET);

    // 평문 포인터 다시 처음으로.

    printf("plaintext length %d \n", plaintext_size); // print to plaintext

    int block_number = plaintext_size / 16;

    int empty_space_in_block = plaintext_size % 16;

    printf("block_number %d empty_space_in_block %d \n",block_number, empty_space_in_block);
    // print

    if(empty_space_in_block != 0){
        aes_block_array = new aes_block [block_number + 1];
    }
    else{
        aes_block_array = new aes_block [block_number];
    }
    // block asign
    char temp_plaintext[16];

    for(int i = 0; i < block_number;){
        fgets(temp_plaintext,16,plaintext_fp);
        for(int j = 0; j < 16; j++){
            aes_block_array[i].block[j] = (unsigned char) temp_plaintext[j];
        }
    }

    if(empty_space_in_block != 0){
        fgets(temp_plaintext,empty_space_in_block,plaintext_fp);
        int start = 0;
        for(int j = 0; j < 16; j++){
            aes_block_array[block_number].block[j] = (unsigned char)temp_plaintext[j];
            start = j + 1;
        }
        // 일단 남은 내용들을 채워준다.
        for(int k = start; k < 16; k ++)
            aes_block_array[block_number].block[k] = '\0';
        block_number++
        //이후 빈공간을 \0으로 채우기
    }

    // plaint text -> aes_block_array

    /*
    plaintext : abcdefghijklmnopqrstu

    aes_block_array[0].block[0]~[16]
    {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o}
    aes_block_array[1].block[0]~[16]
    {p,q,r,s,t,u,\0,\0,\0,\0,\0,\0,\0,\0,\0,\0,\0}
    
    */

    
    FILE* key_fp;

    key_fp = fopen(argv[2],"r");
    char read_key[16];

    fgets(read_key, 16, key_fp);

    /*
    key_expansion
    */







}