
int x;

int main(){

   int a[100];
   int i,j=0;
   int x;
   klee_make_symbolic(&x, sizeof(x), "x");
   klee_assume(x <= 10);
   
   if (x <= 1)
      return 1;
   
   for (i =0; i< x ; ++i){
      j = j +2;
   }

   if ( j >= 2*x)   {
      //a[101]=0; /*-- force an error here! --*/
      a[0]=0;
   }
   
   return j;

}


