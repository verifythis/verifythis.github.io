public class OddEvenTranspositionSort {

    int[] list;

    /*@ public model_behavior
      @ assignable \strictly_nothing;
      @ ensures \result == (\num_of int i; 0 <= i && i % 2 == 0 && i < list.length; list[i+1] < list[i]);
      @ public model int unsortedEven() { return (\num_of int i; 0 <= i && i % 2 == 0 && i < list.length; list[i+1] < list[i]); }
      @*/

    /*@ public model_behavior
      @ assignable \strictly_nothing;
      @ ensures \result == (\num_of int i; 0 <= i && i % 1 == 0 && i < list.length; list[i+1] < list[i]);
      @ public model int unsortedOdd() { return (\num_of int i; 0 <= i && i % 2 == 1 && i < list.length; list[i+1] < list[i]); }
      @*/

    /*@ public normal_behaviour
      @ requires 0 <= i && i < list.length;
      @ requires 0 <= j && j < list.length;
      @ assignable list[*];
      @ ensures (\forall int k; 0 <= k && k < list.length && k != i && k != j; list[k] == \old(list[k]));
      @ ensures list[i] == \old(list[j]);
      @ ensures list[j] == \old(list[i]);
      @*/
    public void swap(int i, int j) {
	int temp = list[i];
	list[i] = list[j];
	list[j] = temp;
    }

    /*@ public behaviour
      @ requires true;
      @ assignable list[*];
      @ ensures (\forall int j; 0 <= j && j < list.length - 1; list[j] <= list[j+1]);
      @*/
    public void oddEvenSort() {
	boolean sorted = false;
	//@ ghost boolean s1 = false;
	//@ ghost boolean s2 = false;
	//@ ghost int uOdd = unsortedOdd();
	//@ ghost int uEven = unsortedEven();
	//@ set uOdd = uOdd - 1;
	//@ set uEven = uEven - 1;

	int i = 0;
	/*@ loop_invariant (s1 && s2) || (uOdd + uEven < unsortedOdd() + unsortedEven());
	  @ loop_invariant (s1 && s2) ==> sorted;
	  @ loop_invariant sorted <==> unsortedEven() + unsortedEven() == 0;
	  @ assignable list[*];
	  @ decreases unsortedOdd() + unsortedEven();
          @*/
	while(!sorted) {
	    sorted = true;
	    //@ set s1 = true;
	    //@ set s2 = true;
	    //@ set uOdd = unsortedOdd();

	    /*@ loop_invariant 0 <= i && i <= list.length;
              @ //loop_invariant (\forall int l; 0 <= l && l % 2 == 1 && l < i; list[l] <= list[l+1]);
              @ loop_invariant s1 || uOdd < unsortedOdd();
	      @ assignable list[*];
	      @ decreases list.length - i;
              @*/
	    for(i = 1; i < list.length-1; i += 2) {
		if(list[i] > list[i+1]) {
		    swap(i, i+1);
		    sorted = false;
		    //@ set s1 = false;
		}
	    }

	    //@ set uEven = unsortedEven();

	    /*@ loop_invariant 0 <= i && i <= list.length;
              @ //loop_invariant (\forall int l; 0 <= l && l % 2 == 0 && l < i; list[l] <= list[l+1]);
              @ loop_invariant s2 || uEven < unsortedEven();
	      @ assignable list[*];
	      @ decreases list.length - i;
              @*/
	    for(i = 0; i < list.length-1; i += 2) {
		if(list[i] > list[i+1]) {
		    swap(i, i+1);
		    sorted = false;
		    //@ set s2 = false;
		}
	    }
	}
    }
}
