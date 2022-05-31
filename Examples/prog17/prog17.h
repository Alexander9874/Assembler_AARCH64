#include <stdio.h>
#include <stdlib.h>

#ifndef TREE
#define TREE

struct Node{
	int k;
	struct Node * l, * r;
};

int Add(struct Node **, int);

void Free(struct Node *);

void Print(struct Node *);

struct Node * Search(struct Node *, int);

int Del(struct Node **, int);

int Addasm(struct Node **, int);

struct Node * Searchasm(struct Node *, int);

int Delasm(struct Node **, int);

#endif
