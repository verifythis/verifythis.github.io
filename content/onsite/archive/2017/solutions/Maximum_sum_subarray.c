/*@ axiomatic Sum {
  @   logic integer sum{L}(int *t, integer i, integer j)
  @        reads t[..] ;
  @   axiom sum1{L} :
  @     \forall int *t, integer i, j; i >= j ==> sum(t,i,j) == 0;
  @   axiom sum2{L} :
  @     \forall int *t, integer i, j; i <= j ==>
  @       sum(t,i,j+1) == sum(t,i,j) + t[j];
  @ }
  @*/

/*@ axiomatic sum_max {
      logic integer sum_max(int* a, integer i, integer j) reads a[..];
      logic integer sum_suf_max(int* a, integer i, integer j) reads a[..];

      axiom sum_max1{L}:
          \forall int *a,integer i,j;
	      \exists integer m,n; 0 <= i <= m <= n <= j && sum_max(a,i,j) == sum(a,m,n);

      axiom sum_max2{L}:
          \forall int *a,integer i,j,n,m;
 	     0 <= i <= m <= n <= j ==> sum_max(a,i,j) >= sum(a,m,n);

      axiom sum_suf_max1{L}:
          \forall int *a,integer i,j;
 	     \exists integer n; 0 <= i <= n <= j && sum_suf_max(a,i,j) == sum(a,n,j);

      axiom sum_suf_max2{L}:
          \forall int *a,integer i,j,m;
 	     0 <= i <= m <= j ==> sum_suf_max(a,i,j) >= sum(a,m,j);

      lemma sum_pos_aux: \forall int* a, integer i, j;
          0 <= i <= j ==> sum(a, j, j) == 0;

      lemma sum_max_pos_aux{L}: \forall int* a, integer i, j;
          0 <= i <= j ==> sum(a,j,j) <= sum_max(a, i, j);

      lemma sum_max_pos{L}: \forall int* a, integer i, j;
          0 <= i <= j ==> 0 <= sum_max(a, i, j);

      lemma sum_suf_max_pos_aux{L}: \forall int* a, integer i, j;
          0 <= i <= j ==> sum(a,j,j) <= sum_suf_max(a, i, j);

      lemma sum_suf_max_pos{L}: \forall int* a, integer i, j;
          0 <= i <= j ==> 0 <= sum_suf_max(a, i, j);

      lemma sum_suf_max_zero{L}:
          \forall int* a, integer n; 0 <= n ==>
          sum_suf_max(a, 0, n+1) == \max (sum_suf_max(a, 0, n)+a[n], 0);

      lemma sum_max_sum_suf_max{L}:
          \forall int *a,integer n; 0 <= n ==>
              sum_max(a,0,n+1) == \max(sum_max(a,0,n),sum_suf_max(a,0,n+1));
}
*/

/*@ requires size >= 0;
  @ requires \valid(a+(0..size));
  @ assigns \nothing;
  @ ensures \result >= 0;
  @ ensures \forall integer m,n; 0 <= m <= n <= size ==> \result >= sum(a,m,n);
  @ ensures \exists integer m,n; 0 <= m <= n <= size && \result == sum(a,m,n);
*/
int maxSubArraySum(int a[], int size)
{
    int max_so_far = 0, max_ending_here = 0;
    /*@ loop assigns i, max_so_far, max_ending_here;
      @ loop invariant 0 <= i <= size;
      @ loop invariant max_ending_here == sum_suf_max(a,0,i);
      @ loop invariant max_so_far == sum_max(a,0,i);
      @ loop variant size - i;
     */
    for (int i = 0; i < size; i++){
      max_ending_here = max_ending_here + a[i];
      if (max_ending_here < 0){
	max_ending_here = 0;
      }
      else{
	if (max_so_far < max_ending_here){
	  max_so_far = max_ending_here;
	}
      }
    }
    return max_so_far;
}


