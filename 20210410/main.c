#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

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

    int plaintext_size;

    fseek(plaintext_fp, 0, SEEK_END);
    plaintext_size = ftell(plaintext_fp);

    // 평문 text size 측정.

    fseek(plaintext_fp, 0, SEEK_SET);

    // 평문 포인터 다시 처음으로.

    printf("plaintext length %d \n", plaintext_size); // print to plaintext

    char *plain_text = (char *)malloc(sizeof(char) * plaintext_size);

    fgets(plain_text, plaintext_size + 1, plaintext_fp);

    printf("plaintext %s\n", plain_text);

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

    char key[16];

    fgets(key, key_size + 1, key_fp);

    printf("key %s \n", key);
}