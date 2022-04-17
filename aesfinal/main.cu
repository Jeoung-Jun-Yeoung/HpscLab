#include "encrypt.cuh"
#include <cstdio>
#include <cstdlib>
#include <cassert>

//ANSIX923

//PKCS7 padding
// "0123456789ABCDEF"
// "\x16\x16\x16....."
// "123" -> 16
// "123\x13\x13\x13...."

// "010203...." -> [0x01, 0x02, 0x03, ..]


int main(int argc, char *argv[])
{
    FILE *plaintext_fp;
    FILE *key_fp;

    plaintext_fp = fopen(argv[1], "rb");

    if (plaintext_fp == NULL)
    {
        printf("the file to encypt does not exist\n");
        return 0;
    }
    // 평문이 담긴 txt 파일 오픈.
    // Hex string

    int plaintext_size;

    fseek(plaintext_fp, 0, SEEK_END);
    plaintext_size = ftell(plaintext_fp);


    // 평문 text size 측정.

    fseek(plaintext_fp, 0, SEEK_SET);

    // 평문 포인터 다시 처음으로.
    int pt_byte_size = plaintext_size/2;
    printf("plaintext length %d \n", plaintext_size); // print to plaintext
    
    //fgets(temp_plain_text, plaintext_size + 1, plaintext_fp);
    BYTE *plain_text = (BYTE *)malloc(sizeof(BYTE) *  pt_byte_size);
    for(int i = 0; i < pt_byte_size; i++){
        char buf[3] = {0, 0, 0};
        fread(buf, 2, 1, plaintext_fp);
        //fseek(plaintext_fp, 2 , SEEK_CUR);
        plain_text[i] = strtol(buf, NULL, 16);
    }

    //for(int i=0; i<pt_byte_size; i++){
      //  printf("%02x ", plain_text[i]);
    //}
    //printf("\n");

    key_fp = fopen(argv[2], "rb");

    if (key_fp == NULL)
    {
        printf("key file does not exist\n");
        return 0;
    }
    // key txt 파일 오픈.

    int key_size;

    fseek(key_fp, 0, SEEK_END);
    key_size = ftell(key_fp);

    // 평문 text size 측정.

    fseek(key_fp, 0, SEEK_SET);

    printf("key length %d \n", key_size);
    assert(key_size == 32);
    key_size = 16;
    BYTE key[16];

    for(int i = 0; i < key_size; i++){
        char buf[3] = {0, 0, 0};
        fread(buf, 2, 1, key_fp);
        key[i] = strtol(buf, NULL, 16);
    }


    BYTE key_expand[16 * (ROUNDS + 1)];

    AES_ExpandKey(key, key_expand);

    //000102030405060708090a0b0c0d0e0f
    
    BYTE *device_p_text;
    BYTE *device_key;

    cudaMalloc(&device_p_text, pt_byte_size);
    cudaMalloc(&device_key, 16 * (ROUNDS + 1));
    cudaMemcpy(device_p_text,plain_text,pt_byte_size,cudaMemcpyHostToDevice);
    cudaMemcpy(device_key, key_expand , 16 * (ROUNDS + 1),cudaMemcpyHostToDevice);

    int thread = atoi(argv[3]);
    printf("threads %d \n", thread);
    dim3 ThreadperBlock(thread);
    int sm = 1;
    dim3 BlokcperGrid(sm);
    cudaEvent_t startEncrypt, endEncrypt;

    float encrypt_time;

    printf("pt_byte: %d \n", pt_byte_size);
    assert (pt_byte_size%16 == 0);

    cudaEventCreate(&startEncrypt);
    cudaEventCreate(&endEncrypt);
    cudaEventRecord(startEncrypt,0);

    Cipher<<<BlokcperGrid,ThreadperBlock>>>(device_p_text, pt_byte_size, device_key, thread);
    cudaMemcpy(plain_text, device_p_text, pt_byte_size,cudaMemcpyDeviceToHost);
    
    cudaEventRecord(endEncrypt,0);
    cudaEventSynchronize(endEncrypt);
    cudaEventElapsedTime(&encrypt_time, startEncrypt, endEncrypt);



    cudaError_t err;
    err = cudaGetLastError(); // `cudaGetLastError` will return the error from above.
    // thread 숫자를 256개 이상 쓰면 waring : Too Many Resources Requested for Launch
    if (err != cudaSuccess)
    {
        printf("Error: %s\n", cudaGetErrorString(err));
    }   


    // 결과 기록용
    printf("\nEncrypt time %f ms \n",encrypt_time);

    FILE* timefp = fopen("5000kb_measure.txt","a");
    fprintf(timefp,"thread %d ",thread);
    fprintf(timefp,"Encrypt time %f ms \n",encrypt_time);
    fclose(timefp);
    // 2 4 8 16 32 64 128 256 512 1024
   
    //for(int i=0; i<pt_byte_size; i++){
    //   printf("%02x ", plain_text[i]);
    //}
    
    //printf("\n");
    
}