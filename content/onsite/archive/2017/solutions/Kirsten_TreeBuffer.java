public class TreeBuffer {

    public int h;
    public int[] xs;

    /*@ public normal_behaviour
      @ requires 0 <= i;
      @ ensures xs.length == 0;
      @ ensures h == i;
      @*/
    public TreeBuffer(int i) {
	h = i;
	xs = new int[]{};
    }

    /*@ public normal_behaviour
      @ assignable xs;
      @ ensures xs[0] == a;
      @ ensures xs.length == \old(xs.length) + 1;
      @ ensures (\forall int i; 1 <= i && i < xs.length; xs[i] == \old(xs[i-1]));
      @*/
    public TreeBuffer add(int a) {
	int[] t = new int[xs.length + 1];
	t[0] = a;
	for (int i = 0; i < xs.length; i++) {
	    t[i+1] = xs[i];
	}
	xs = t;
	return this;
    }

    /*@ public normal_behaviour
      @ assignable \strictly_nothing;
      @ ensures xs.length <= h ==> \result.length == xs.length;
      @ ensures xs.length > h ==> \result.length == h;
      @ ensures (\forall int i; 0 <= i && i < \result.length; \result[i] == xs[i]);
      @*/
    public int[] get() {
	int pos = h;
	if (xs.length <= h) {
	    pos = xs.length;
	}
	int[] t = new int[pos];
	for (int i = 0; i < pos; i++) {
	    t[i] = xs[i];
	}
	return t;
    }
}

public class CaterpillarTreeBuffer {

    public int h;
    public int[] xs;
    public int xs_len;
    public int[] ys;

    /*@ public normal_behaviour
      @ requires 0 <= i;
      @ ensures xs.length == 0;
      @ ensures h == i;
      @*/
    public CaterpillarTreeBuffer(int i) {
	h = i;
	xs = new int[0];
	xs_len = 0;
	ys = new int[0];
    }

    /*@ public normal_behaviour
      @ assignable xs;
      @ ensures xs[0] == a;
      @ ensures xs.length == \old(xs.length) + 1;
      @ ensures (\forall int i; 1 <= i && i < xs.length; xs[i] == \old(xs[i-1]));
      @*/
    public void add(int a) {
	if (xs_len == h - 1) {
	    xs = new int[]{};
	    xs_len = 0;
	    ys = new int[xs.length + 1];
	    ys[0] = a;
	    for (int i = 0; i < xs.length; i++) {
		ys[i+1] = xs[i];
	    }
	} else {
	    int[] xs_prime = new int[xs.length + 1];
	    xs_prime[0] = a;
	    for (int i = 0; i < xs.length; i++) {
		xs_prime[i+1] = xs[i];
	    }
	    xs_len = xs_len + 1;
	}
    }

    /*@ public normal_behaviour
      @ assignable \strictly_nothing;
      @ ensures xs.length <= h ==> \result.length == xs.length;
      @ ensures xs.length > h ==> \result.length == h;
      @ ensures (\forall int i; 0 <= i && i < \result.length; \result[i] == xs[i]);
      @*/
    public int[] get() {
	int a = h;
	int[] t = new int[h];
	for (int i = 0; i < xs.length; i++) {
	    t[i] = xs[i];
	}
	for (int j = 0; j < h - xs.length; j++) {
	    t[j + xs.length - 1] = ys[j];
	}
	return t;
    }
}
