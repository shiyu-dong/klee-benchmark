#define NULL 0

typedef struct {

  int x;
  int y;
  void * z;

} st_t;

st_t * st_alloc(int x, int y){
  st_t * t = (st_t *) malloc(1 * sizeof(st_t));
  if ( x >  0 && y >  0){
    t -> x = x;
    t -> y = y;
    t -> z = NULL;
  } else {

    t -> x = 0;
    t -> y = 0;
    t -> z = (void *) malloc (100 * sizeof(int));
  }
  return t;
}

int st_compact(st_t * st1, st_t * st2){
  if (st1 -> z > 0 ){
    if (st2 -> z > 0 ){
      ASSERT(st1 -> x > 0);
      ASSERT(st2 -> y > 0);
    } else {
      st2 -> x = st1 -> x;
      st2 -> y = -1;
      st1 -> z = st2 -> z;
      st2 -> z = NULL;
    }
  }

  return st1 -> x;

}

int main(int a, int b){
  st_t * st1, * st2;
  ASSUME(a> 0);
  ASSUME(b > 0);
  
  st1 = st_alloc(a,b);
  
  st2 = st_alloc(-b,-a);
  
  
  st_compact(st1,st2);
  return 1;

}
