#include<stdio.h>

int fibonacci(int n){
	if (n <= 1)
		return n;
	else
		return fibonacci(n-1) + fibonacci(n-2);
}
 
int main (){
  int n = 9;
  *(int*)0x07FC =  fibonacci(n);
  while(1){}
  return 0;
}
