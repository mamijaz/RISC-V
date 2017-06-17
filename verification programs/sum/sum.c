#include<stdio.h>
 
int sum(int n);

int main (){
  int n = 9;
  *(int*)0x07FC =  sum(n);
  while(1){}
  return 0;
}

int sum(int n){
  int s = 0;
  int i;
  for(i=0;i<=n;i++){
    s += i;
  }
  return s;
}
