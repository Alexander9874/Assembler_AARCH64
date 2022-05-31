#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <time.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "prog18.h"

int main(int argc, char * argv[]){
	long bufin[8192], bufout[8912];
	char * p;
	struct timespec t, t1, t2;
	long key;
	int fin, fout, i, l, m;
	if (argc!=4){
		fprintf(stderr, "Usage: %s key infile outfile\n", argv[0]);
		return 1;
	}
	key=strtol(argv[1], &p, 0);
	if (*p){
		fprintf(stderr, "%s: invald key\n", argv[1]);
		return 1;
	}
	if ((fin=open(argv[2], O_RDONLY))==-1){
		perror(argv[2]);
		return 1;
	}
	fout=open(argv[3], O_WRONLY | O_CREAT | O_EXCL, 0600);
	if (fout==-1 && errno==EEXIST){
		fprintf(stderr, "File %s exists. Rewrite?(Y/N)\n", argv[3]);
		read(0, bufin, 8);
		if ((bufin[0]&0xff)=='Y' || (bufin[0]&0xff)=='y')
			fout=open(argv[3], O_WRONLY | O_TRUNC);
	}
	if (fout==-1){
		perror(argv[3]);
		close(fin);
		return 1;
	}
	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t1);
	while ((l=read(fin, bufin, 65536))>0){
		cipher(bufin, bufout, key, l);
		for (i=0; i<l && (m=write(fout, &bufout[i], l-i))>0; i+=m);
		if (m<=0)
			break;
	}
	if (l<0 || m<=0){
		close(fin);
		close(fout);
		return 1;
	}
	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t2);
	t.tv_sec=t2.tv_sec-t1.tv_sec;
	if ((t.tv_nsec=t2.tv_nsec-t1.tv_nsec)<0){
		t.tv_sec--;
		t.tv_nsec+=1000000000;
	}
	close(fin);
	close(fout);
	printf("Test: %ld.%09ld\n", t.tv_sec, t.tv_nsec);
	return 0;
}
