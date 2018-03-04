//Greg Morphis
//Project 4.1
//Due : 11/18
//using a recursive insert function on a tree
// This is another binary tree program using recursion to
// insert a list of presidents into a binary tree

#include<stdio.h>
#include<string.h>
#include<math.h>
#include<stdlib.h>

typedef char prezname[25];
prezname pres[50];
typedef struct cell *tref;
typedef struct cell
{
	prezname prez;
	tref left;
	tref right;
}tnode;

int n = 1;

FILE *inptr, *outptr;

void insrt(tref *root,prezname keyname);
void nlr(tref root);

int main(void)
{
	tref root;
	prezname keyname;
	int i = 0;

	root = NULL;

	inptr = fopen("prez.txt","r");
	outptr = fopen("outfile.txt","w");

	while(fscanf(inptr, "%s", keyname) != EOF)
		insrt(&root, keyname);
	nlr(root);
	
	return 0;
}

void nlr(tref root)
{
	if(root != NULL)
	{
		fprintf(outptr,"Node = %s\n",root->prez);
		if(root->left == NULL)
			fprintf(outptr,"Left = NULL\n");
		else
			fprintf(outptr,"Left = %s\n",root->left);

		if(root->right == NULL)
			fprintf(outptr,"Right = NULL\n");
		else
			fprintf(outptr,"Right = %s\n",root->right);
		fprintf(outptr,"\n\n");
		nlr(root->left);
		nlr(root->right);
	}
}

void insrt(tref *root,prezname keyname)
{
	if((*root) == NULL)
	{
		*root = (tref)malloc(sizeof(tnode));
		strcpy((*root)->prez,keyname);
		(*root)->left = NULL;
		(*root)->right = NULL;

	}
	else if(strcmp(keyname,(*root)->prez)<0)
		insrt(&(*root)->left,keyname);
	else
		insrt(&(*root)->right,keyname);
}
