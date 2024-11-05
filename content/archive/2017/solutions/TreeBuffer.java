package challenge3;
/*
 * Only tentative specificaiton for this challenge.
 * -catterpilar version is implemented
 * -naive version is represented by orig ghost field
 * -functional equivalence given by invariant saying that catterpillar implementation is basically a prefix for the naive one.
 **/
public class TreeBuffer {
	
	int h;
	
	TreeBuffer[] xs;
	
	TreeBuffer[] ys;
	
	//@public model \seq content;
	//@public represents content \such_that content == \dl_seqConcat(\dl_array2seq(xs), \dl_array2seq(ys));
	
	//@ ghost \seq orig;
	
	//@ invariant content == \dl_seqSub(orig,0,\dl_seqLen(content));
	
	public TreeBuffer(int h){
		this.h  = h;
		this.xs = new TreeBuffer[0];
		this.ys = new TreeBuffer[0];
	}
	/*@public normal_behaviour
	   ensures \dl_array2seq(\result) == \dl_seqConcat(\dl_seqSingleton(t), \dl_array2seq(buf));
	   assignable \nothing;
	@*/
	public TreeBuffer[] addOne(TreeBuffer[] buf, TreeBuffer t){
		TreeBuffer[] newbuffer = new TreeBuffer[buf.length+1];
		newbuffer[0] = t;
		for (int i = 0; i < buf.length; i++) {
			newbuffer[i+1] = buf[i];
		}		
		return newbuffer;
	}
	/*@ public normal_behaviour
	    ensures true;	 
	@*/
	public void add(TreeBuffer t){
		if(xs.length == h - 1){
			this.ys = addOne(xs,t);
			xs  = new TreeBuffer[0];
		}
		else{
			this.xs = addOne(xs,t);
		}
		//@set orig = \dl_seqConcat(\dl_seqSingleton(t), orig);
	}
	/*@ public normal_behaviour
	    requires xs.length + ys.length >= h; //I didn't understand what should happen if less than h elements in treebuffer
        ensures \dl_array2seq(\result) == \dl_seqSub(content,0,h);	 
    @*/
	public TreeBuffer[] get(){
		
		TreeBuffer[] result = new TreeBuffer[h];
		
		
		int i = 0;
		while (i < xs.length) {
			result[i] = xs[i];
			i++;
		}
		
		int rest = h - xs.length;
		int j = 0;
		while(j < rest){
			result[i] =ys[j];
			i++;
			j++;
		}
		
		return result;
		
	}
	
	

}
