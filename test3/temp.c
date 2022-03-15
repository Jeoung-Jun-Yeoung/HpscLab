#include <stdio.h>

void add (int a, int b, int *c){
	*c = a + b;
}


int main(int argc, char const *argv[])
{
	int c;
	c = 1;
	printf("%d",c);
	return 0;
}
//"CUDA C++",
		"CUDA Snippets",
	