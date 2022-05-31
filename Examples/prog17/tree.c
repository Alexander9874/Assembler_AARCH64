#include <stdio.h>
#include <stdlib.h>
#include "prog17.h"

int Add(struct Node ** proot, int k){
	struct Node ** pp;
	for (pp=proot; *pp && (*pp)->k!=k; pp=k<(*pp)->k?&(*pp)->l:&(*pp)->r);
	if (*pp)
		return 0;
	if (!(*pp=malloc(sizeof(struct Node))))
		return 0;
	(*pp)->k=k;
	(*pp)->l=(*pp)->r=NULL;
	return 1;
}

void Free(struct Node * root){
	if (root){
		Free(root->l);
		Free(root->r);
		free(root);
	}
}

void Print(struct Node * root){
	if (root){
		Print(root->l);
		printf("%d\n", root->k);
		Print(root->r);
	}
}

struct Node * Search(struct Node * root, int k){
	for (; root && root->k!=k; root=k<root->k?root->l:root->r);
	return root;
}

int Del(struct Node ** proot, int k){
	struct Node ** pp, * q;
	for (pp=proot; *pp && (*pp)->k!=k; pp=k<(*pp)->k?&(*pp)->l:&(*pp)->r);
	if (!*pp)
		return 0;
	q=*pp;
	if (q->l && q->r){
		for (pp=&(*pp)->l; (*pp)->r; pp=&(*pp)->r);
		q->k=(*pp)->k;
		q=*pp;
	}
	*pp=(*pp)->l?(*pp)->l:(*pp)->r;
	free(q);
	return 1;
}
