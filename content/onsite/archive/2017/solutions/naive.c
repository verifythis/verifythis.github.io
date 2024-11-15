/* This is an implementation of the naive version in C with ACSL annotations. */

#include <stdlib.h>

struct buff {
  int h;
  int n;
  int tab [1000];
};

/*@ predicate valid_empty_buff(integer h, struct buff b) =
  @     b.h == h && b.n == 0 && (\forall integer k; 0 <= k < 1000 ==> b.tab[k] == 0);
*/

/*@ requires 0 <= h < 1000;
  @ assigns \nothing;
  @ ensures valid_empty_buff(h,\result);*/
struct buff empty (int h){
    struct buff temp;
    temp.h = h;
    temp.n = 0;
    /*@ loop assigns i, temp.tab[0..1000];
      @ loop invariant 0 <= i <= 1000;
      @ loop invariant \forall integer k; 0 <= k < i ==> temp.tab[k] == 0;
     */
    for(int i = 0; i < 1000; i++){
      temp.tab[i] = 0;
    }
    return temp;
}


/*@ requires b.n < 1000 && b.h < 1000;
  @ behavior full_buffer:
     assumes b.n + 1 >= 1000;
     assigns \nothing;
  @ behavior good:
     assumes b.n < 1000;
     assigns \result \from b,a;
     ensures \forall integer k; 0 <= k <= \at(b.n,Pre) ==> \result.tab[k] == \at(b.tab[k],Pre);
     ensures \result.tab[\at(b.n,Pre) + 1] == a;
 */
struct buff add (struct buff b, int a){
  if ( b.n + 1 < 1000){
    b.n = b.n + 1;
    b.tab[b.n] = a;
  }
  else {
    exit(1);
  }
  return b;
}

/*@ requires \valid(t+(0..b.h));
  @ requires b.h > 0;
  @ requires b.n > 0;
  @ requires b.n < 1000 && b.h < 1000;
  @ assigns t[0..b.h];
*/
void get (int t[], struct buff b){
  int j = 0;
  /*@ loop assigns t[0..b.h],j;
    @ loop invariant \forall integer k; 0 <= k < j ==> t[k] == \at(b.tab[b.n - k],Pre);
    @ loop invariant 0 <= j;
    @ loop invariant j <= b.n + 1 && j <= b.h + 1;
    @ loop variant b.n-j;
   */
  while(b.n-j >= 0 && b.h-j >= 0){
    t[j] = b.tab[b.n - j];
    j ++;
  }
 }

