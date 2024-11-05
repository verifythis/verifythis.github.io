// Command: frama-c -wp -wp-rte program.c
// Frama-c version : Silicon (last release)
// The algorithm is proved to sort, but does not ensure the preservation of the elements of the initial array

// swap and same_elements are from http://nikolai.kosmatov.free.fr/publications/tutorial_2013_06_18_tap2013_slides.pdf

/*@ predicate swap{L1, L2}(int *a, int *b, integer begin, integer i, integer j, integer end) =
      begin <= i < j < end &&
      \at(a[i], L1) == \at(b[j], L2) &&
      \at(a[j], L1) == \at(b[i], L2) &&
      \forall integer k; begin <= k < end && k != i && k != j ==>
        \at(a[k], L1) == \at(b[k], L2);

    predicate same_array{L1,L2}(int *a, int *b, integer begin, integer end) =
      \forall integer k; begin <= k < end ==> \at(a[k],L1) == \at(b[k],L2);

    inductive same_elements{L1, L2}(int *a, int *b, integer begin, integer end) {
      case refl{L1, L2}:
        \forall int *a, int *b, integer begin, end;
        same_array{L1,L2}(a, b, begin, end) ==>
        same_elements{L1, L2}(a, b, begin, end);
      case swap{L1, L2}: \forall int *a, int *b, integer begin, i, j, end;
        swap{L1, L2}(a, b, begin, i, j, end) ==>
        same_elements{L1, L2}(a, b, begin, end);
      case trans{L1, L2, L3}: \forall int* a, int *b, int *c, integer begin, end;
        same_elements{L1, L2}(a, b, begin, end) ==>
        same_elements{L2, L3}(b, c, begin, end) ==>
        same_elements{L1, L3}(a, c, begin, end);
    }
*/

/*@ ghost int *t;*/

/*@ requires \valid(t+(0..n-1));
    requires \separated(t+(0..n-1),a+(0..n-1));
    requires same_array{Pre, Pre}(a, t, 0, n);
    requires n >= 0;
    requires \valid(a+(0..n-1));
    assigns a[0..n-1],t[0..n-1];
    ensures sorted: \forall integer i, j; 0 <= i <= j < n ==> a[i] <= a[j]; // the final array is sorted
    ensures \forall integer k; 0 <= k < n ==> a[k] == t[k];
    ensures same_elements{Pre, Post}(t, t, 0, n);
    ensures same_elements{Pre, Post}(a, a, 0, n); // the array contains the same elements at the end as in the beginning
*/
void pair_sort(int a[], int n) {
  int i = 0; // i is running index (inc by 2 every iteration)

  /*@ loop invariant \forall integer k, l; 0 <= k <= l < i ==> a[k] <= a[l]; // the sub-array a[0..i-1] is sorted
      loop invariant same_elements{Pre, Here}(t, t, 0, n);
      loop invariant \forall integer k; 0 <= k < n ==> a[k] == t[k];
      loop invariant 0 <= i <= n;
      loop assigns i, a[0..n-1],t[0..n-1];
      loop variant n - 1 - i;
  */
  while (i < n-1) {
    int x = a[i];
    // let x and y hold the next to elements in A
    int y = a[i+1];

    if (x < y) {
      // ensure that x is not smaller than y
        int tmp = x;
        x = y;
        y = tmp;
    }
    int j = i - 1;
    // j is the index used to find the insertion point
    /*@ loop invariant \forall integer k, l; 0 <= k <= l <= j ==> a[k] <= a[l]; // the sub-array a[0..j] is sorted
        loop invariant \forall integer k, l; j+2 < k <= l <= i+1 ==> a[k] <= a[l]; // the sub-array a[j+3..i+1] is sorted
        loop invariant \forall integer k, l; 0 <= k <= j && j +2 < l <= i+1 ==> a[k] <= a[l]; // every element in a[0..j] is no more then every element in a[j+3..i+1]
        loop invariant \forall integer k; j+2 < k <= i+1 ==> x < a[k]; // every element in a[j+3..i+1] is more than x
        loop invariant -1 <= j <= i - 1;
	loop invariant same_elements{Pre, Here}(t, t, 0, n);
	loop invariant \forall integer k; j+2 < k <= i+1 ==> a[k] == t[k];
	loop invariant \forall integer k; i+1 < k < n ==> a[k] == t[k];
	loop invariant \forall integer k; 0 <= k <= j ==> a[k] == t[k];
	loop invariant (t[j+1] == x && t[j+2] == y) || (t[j+1] == y && t[j+2] == x);
	loop assigns a[0..n-1],j,t[0..n-1];
	loop variant j;
    */
    while (j >= 0 && a[j] > x)	{
      // find the insertion point for x
      /*@ ghost L1:;*/
      a[j+2] = a[j];
      // shift existing content by 2
      /*@ ghost int temp = t[j];*/
      /*@ ghost t[j] = t[j+2];*/
      /*@ ghost t[j+2] = temp;*/
      /*@ assert swap{L1, Here}(t, t, 0, j, j+2, n);*/
      j = j - 1;
    }
    /*@ ghost Test:;*/
    /*@ assert \forall integer k; j+3 <= k < n ==> a[k] == t[k];*/
    /*@ assert same_elements{Pre, Here}(t, t, 0, n);*/
    /*@ assert (t[j+1] == x && t[j+2] == y) || (t[j+1] == y && t[j+2] == x);*/
    a[j+2] = x;
    /*@ assert same_elements{Test, Here}(t, t, 0, n);*/
    /*@ assert same_elements{Pre, Here}(t, t, 0, n);*/
    /*@ assert \forall integer k; j+3 <= k < n ==> a[k] == t[k];*/
    /*@ ghost if(t[j+2] == y){t[j+2] = x;t[j+1] = y;} else {} ;*/
    /*@ assert \at(t[j+2],Test) == y ==> swap{Test,Here}(t,t, 0,j+1,j+2,n);*/
    /*@ assert \at(t[j+2],Test) != y ==>  (\forall integer k; 0 <= k < n ==>  \at(t[k],Here) == \at(t[k],Test));*/
    /*@ assert t[j+2] == x && t[j+1] == y;*/
    /*@ assert same_elements{Test, Here}(t, t, 0, n);*/
    /*@ assert same_elements{Pre, Here}(t, t, 0, n);*/
    /*@ assert \forall integer k; j+2 <= k < n ==> a[k] == t[k];*/

    // store x at its insertion place
    // A[j+1] is an available space now
    /*@ assert \at(j,Here) == \at(j,Test);*/
    /*@ loop invariant \forall integer k, l; 0 <= k <= l <= j ==> a[k] <= a[l]; // the sub-array a[0..j] is sorted
        loop invariant \forall integer k, l; j+1 < k <= l <= i+1 ==> a[k] <= a[l]; // the sub-array a[j+2..i+1] is sorted
        loop invariant \forall integer k, l; 0 <= k <= j && j +1 < l <= i+1 ==> a[k] <= a[l]; // every element in a[0..j] is no more then every element in a[j+2..i+1]
        loop invariant \forall integer k; j+1 < k <= i+1 ==> y <= a[k]; // every element in a[j+2..i+1] is more than x
        loop invariant -1 <= j <= \at(j, LoopEntry); // j varies between -1 and its value at the loop entry
	loop invariant same_elements{Pre, Here}(t, t, 0, n);
	loop invariant \forall integer k; j+1 < k <= i+1 ==> a[k] == t[k];
	loop invariant \forall integer k; i+1 < k < n ==> a[k] == t[k];
	loop invariant \forall integer k; 0 <= k <= j ==> a[k] == t[k];
	loop invariant t[j+1] == y;
	loop assigns a[0..n-1],j,t[0..n-1];
	loop variant j;
    */
    while (j >= 0 && a[j] > y) {
      // find the insertion point for y
      /*@ ghost L2:;*/
      a[j+1] = a[j];
      /*@ ghost int temp = t[j];*/
      /*@ ghost t[j] = t[j+1];*/
      /*@ ghost t[j+1] = temp;*/
      /*@ assert swap{L2, Here}(t, t, 0, j, j+1, n);*/
      // shift existing content by 1
      j = j - 1;
    }
    /*@ ghost Test2:;*/
    /*@ assert \forall integer k; j+2 <= k < n ==> a[k] == t[k];*/
    /*@ assert same_elements{Pre, Here}(t, t, 0, n);*/
    /*@ assert t[j+1] == y;*/
    a[j+1] = y;	// store y at its insertion place
    /*@ assert same_elements{Test2, Here}(t, t, 0, n);*/
    /*@ assert same_elements{Pre, Here}(t, t, 0, n);*/
    /*@ assert \forall integer k; j+1 <= k < n ==> a[k] == t[k];*/
  i = i+2;
  }
  if (i == n-1) {
    // if length(A) is odd, an extra
    int y = a[i];
    // single insertion is needed for
    int j = i - 1;
    // the last element
    /*@ loop invariant \forall integer k, l; 0 <= k <= l <= j ==> a[k] <= a[l]; // every element in a[0..j] is more than x
        loop invariant \forall integer k, l; j+1 < k <= l < n ==> a[k] <= a[l]; // every element in a[j+2..n-1] is more than x
        loop invariant \forall integer k, l; 0 <= k <= j && j +1 < l < n ==> a[k] <= a[l]; // every element in a[0..j] is no more then every element in a[j+2..n-1]
        loop invariant \forall integer k; j+1 < k < n ==> y <= a[k]; // every element in a[j+2..n-1] is no less then y
        loop invariant -1 <= j <= i-1;
	loop invariant same_elements{Pre, Here}(t, t, 0, n);
	loop invariant \forall integer k; j+1 < k <= i-1 ==> a[k] == t[k];
	loop invariant \forall integer k; i <= k < n ==> a[k] == t[k];
	loop invariant \forall integer k; 0 <= k <= j ==> a[k] == t[k];
	loop invariant t[j+1] == y;
	loop assigns a[0..n-1],j,t[0..n-1];
	loop variant j;
    */
      while (j >= 0 && a[j] > y) {
      /*@ ghost L3:;*/
      a[j+1] = a[j];
      /*@ ghost int temp = t[j];*/
      /*@ ghost t[j] = t[j+1];*/
      /*@ ghost t[j+1] = temp;*/
      /*@ assert swap{L3, Here}(t, t, 0, j, j+1, n);*/
      j = j - 1;
    }
    /*@ ghost Test3:;*/
    /*@ assert \forall integer k; j+2 <= k < n ==> a[k] == t[k];*/
    /*@ assert same_elements{Pre, Here}(t, t, 0, n);*/
    /*@ assert t[j+1] == y;*/
    a[j+1] = y;
    /*@ assert same_elements{Test3, Here}(t, t, 0, n);*/
    /*@ assert same_elements{Pre, Here}(t, t, 0, n);*/
    /*@ assert \forall integer k; j+1 <= k < n ==> a[k] == t[k];*/
  }
  //@ assert same_array{Pre, Pre}(a, t, 0, n);
  //@ assert same_elements{Pre, Here}(t, t, 0, n);
  //@ assert same_array{Here, Here}(t, a, 0, n);
  //@ assert same_elements{Pre, Here}(a, a, 0, n);
}


