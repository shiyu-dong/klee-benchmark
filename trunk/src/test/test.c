int main() {
  int a;
  int i;
  klee_make_symbolic(&a, sizeof(a), "a");
  int s = 0;
  int v;
  if ((a >= 0) && (a < 4)){
    for (i = 0; i < a; i++) {
      v = 4*i;
      s = s+v;
    }
  }
  return s;
}
