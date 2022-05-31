void cipher(char * in, char * out, long key, int len){
	long * lin=(long *)in, * lout=(long *)out;
	union {
		long a;
		char b[8];
	} u1, u2;
	int i, count, rem;
	count=len/8;
	rem=len%8;
	for (i=0; i<count; i++)
		lout[i]=lin[i]^key;
	for (i=0; i<rem; i++)
		u1.b[i]=in[count*8+i];
	u2.a=u1.a^key;
	for (i=0; i<rem; i++)
		out[count*8+i]=u2.b[i];
}
