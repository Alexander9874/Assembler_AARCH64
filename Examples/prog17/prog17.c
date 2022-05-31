#include <stdio.h>
#include <time.h>
#include "prog17.h"

int main(){
	struct timespec t, t1, t2;
	struct Node * root=NULL;
	int a, i;
	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t1);
	for (i=0; i<1000000; i++)
		scanf("%d", &a), Add(&root, a);
	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t2);
	t.tv_sec=t2.tv_sec-t1.tv_sec;
	if ((t.tv_nsec=t2.tv_nsec-t1.tv_nsec)<0){
		t.tv_sec--;
		t.tv_nsec+=1000000000;
	}
	printf("Add: %ld.%09ld\n", t.tv_sec, t.tv_nsec);
	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t1);
	for (i=0; i<1000000; i++)
		Del(&root, i);
	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t2);
	t.tv_sec=t2.tv_sec-t1.tv_sec;
	if ((t.tv_nsec=t2.tv_nsec-t1.tv_nsec)<0){
		t.tv_sec--;
		t.tv_nsec+=1000000000;
	}
	printf("Del: %ld.%09ld\n", t.tv_sec, t.tv_nsec);
	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t1);
	for (i=0; i<1000000; i++)
		scanf("%d", &a), Addasm(&root, a);
	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t2);
	t.tv_sec=t2.tv_sec-t1.tv_sec;
	if ((t.tv_nsec=t2.tv_nsec-t1.tv_nsec)<0){
		t.tv_sec--;
		t.tv_nsec+=1000000000;
	}
	printf("Addasm: %ld.%09ld\n", t.tv_sec, t.tv_nsec);
	for (i=0; i<1000000; i++)
		if (Search(root, i)!=Searchasm(root, i))
			printf("%d\n", i);
	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t1);
	for (i=0; i<1000000; i++)
		Search(root, i);
	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t2);
	t.tv_sec=t2.tv_sec-t1.tv_sec;
	if ((t.tv_nsec=t2.tv_nsec-t1.tv_nsec)<0){
		t.tv_sec--;
		t.tv_nsec+=1000000000;
	}
	printf("Search: %ld.%09ld\n", t.tv_sec, t.tv_nsec);
	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t1);
	for (i=0; i<100000; i++)
		Searchasm(root, i);
	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t2);
	t.tv_sec=t2.tv_sec-t1.tv_sec;
	if ((t.tv_nsec=t2.tv_nsec-t1.tv_nsec)<0){
		t.tv_sec--;
		t.tv_nsec+=1000000000;
	}
	printf("Seacrhasm: %ld.%09ld\n", t.tv_sec, t.tv_nsec);
	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t1);
	for (i=0; i<1000000; i++)
		Delasm(&root, i);
	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t2);
	t.tv_sec=t2.tv_sec-t1.tv_sec;
	if ((t.tv_nsec=t2.tv_nsec-t1.tv_nsec)<0){
		t.tv_sec--;
		t.tv_nsec+=1000000000;
	}
	printf("Delasm: %ld.%09ld\n", t.tv_sec, t.tv_nsec);
	Free(root);
	return 0;
}
