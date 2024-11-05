package challenge1;


/*Mihai Herda
 * 
 * Refactored the code a bit. Started specifying and verifying the shift1Right method, but got stuck.
 * 
 * 
 * */
public class Sort {
	
	 /*@ public normal_behaviour
	     requires 0 <= i && i < a.length - 1;
	     ensures \result == (a[i] < a[i+1] ? a[i+1] : a[i]);
	     assignable \strictly_nothing;	 
	 @*/
	 private int getX(int[] a, int i){
		 int x = a[i];
		 int y = a[i+1];
		 if(x < y){
			 return y;
		 }
		 else{
			 return x;
		 }
	 }
	 /*@ public normal_behaviour
     requires 0 <= i && i < a.length - 1;
     ensures \result == (a[i] < a[i+1] ? a[i] : a[i+1]);
     assignable \strictly_nothing;	 
     @*/
	 private int getY(int[] a, int i){
		 int x = a[i];
		 int y = a[i+1];
		 if(x < y){
			 return x;
		 }
		 else{
			 return y;
		 }
	 }
     /*@ public normal_behaviour
         ensures (\forall int i; 0 <= i && i < a.length -1; a[i] <= a[i+1]);
         assignable a[*];
      @*/
	 public void sort(int[] a){
		int i = 0;
		/*@
		loop_invariant 0 <= i && i <= a.length - 1;
		loop_invariant (\forall int j; 0 <= j && j < i; a[i] <= a[i+1]);
		decreases a.length -1;
		assignable a[*];
		@*/
		while(i < a.length - 1){
			int x = getX(a,i);
			int y = getY(a,i);			
			
			int j = i - 1;
			
			j = shift2Right(a, x, j);
			a[j+2] = x;
			
			j = shift1Right(a, y, j);
			a[j+1] = y;
			
			i = i+2;
		}
		
		if( i == a.length - 1){
			int y = a[i];
			int j = i-1;
			j = shift1Right(a, y, j);
			a[j+1] = y;
		}
	 }
	/*@ public normal_behaviour
	    requires 0 <= c && c < a.length - 1;
	    ensures (\forall int i; 0 <= i && i <= \result; a[i] == \old(a[i]));
	    ensures (\forall int i; \result + 1 < i && i <= c; a[i] == \old(a[i-1]));
	    ensures -1 <= \result && \result <=c;	    
	    ensures (\forall int i; \result + 1 < i && i <= c; a[i] <= y);
        assignable a[0..c+1]; 
	@*/
	private int shift1Right(int[] a, int y, int c) {
		int j = c;
		/*@
		  loop_invariant 0 <= c && c < a.length - 1;
	      loop_invariant c >= j && j >= -1;	     
	      loop_invariant (\forall int k; 0<=k && k<=j; a[k]==\old(a[k]));
	      loop_invariant (\forall int k; j+1 < k && k<=c; a[k]==\old(a[k-1]));
	      loop_invariant (\forall int k; j+1 < k && k <= c; a[k] <= j);
	      assignable a[0..c+1]; 
	      decreases j+1;
	      @*/
		while(j >= 0 && a[j] > y){
			a[j+1] = a[j];
			j = j-1;
		}
		return j;
	}

	private int shift2Right(int[] a, int x, int j) {
		while(j >= 0 && a[j] > x){
			a[j+2] = a[j];
			j = j - 1;
		}
		return j;
	}
	

}
