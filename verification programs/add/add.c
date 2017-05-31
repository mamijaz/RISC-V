#include <stdio.h>

int main(){
	int a = 10;
	int b = 20;
	*(int*)0x07FC = a+b;

	while(1){}

	return 0;
}
