#include <stdlib.h>
#include <unistd.h>
#include "k.h"

int h;
char *SYM[]={"BML","IBM","MSFT","SUN",NULL};
char COND[]=" 89ABCEGJKLNOPRTWZ";
char EX[]="ON";

int roll(int x){return rand()%x;}

void maketrade(int x)
{
  int i;
  K sym=ktn(KS,x);
  K price=ktn(KF,x);
  K size=ktn(KI,x);
  K stop=ktn(KB,x);
  K cond=ktn(KC,x);
  K ex=ktn(KC,x);
  for(i=0;i<x;i++){
    kS(sym)[i]=ss(SYM[roll(4)]);
    kF(price)[i]=100+0.01*roll(1000);
    kI(size)[i]=100+roll(1000);
    kG(stop)[i]=roll(2);
    kC(cond)[i]=COND[roll(18)];
    kC(ex)[i]=EX[roll(2)];
  }
  K tab=knk(6,sym,price,size,stop,cond,ex);
  k(-h,"upd",ks("trade"),tab,(K)0);
}

// runs for about a minute
int main() {
  h=khp("localhost",5010);
  int len=500;
  while(len--){
    maketrade(1+roll(10));
    usleep(107000);
  }
  return 0;
}
