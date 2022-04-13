#include "encrypt.cuh"


int main(int argc, char *argv[]){

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

}