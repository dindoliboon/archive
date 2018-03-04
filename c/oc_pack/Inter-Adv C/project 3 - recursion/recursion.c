/////////////////////////////////
//Greg Morphis
//Project 3
//Due : 11/12
//Balancing a tree
/////////////////////////////////
//email: omenchaos@hotmail.com
/////////////////////////////////





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

void insert(tref *root, prezname keyname);
void searchfnc(tref root, prezname keyname, int *found, tref *where, tref *whereprev);
void balance(int lft, int rght, tref *root);
void lnr(tref root);
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
		insert(&root, keyname);

	lnr(root);

	balance(1,n-1,&root);

	for(i = 1; i <= n; i++)
		fprintf(outptr,"%s\n",pres[i]);

	nlr(root);

	return 0;


}
/* searches the binary tree to see where node should go or if node is already there */
void searchfnc(tref root, prezname keyname, int *found, tref *where, tref *whereprev)
{
	*whereprev = NULL;
	*where = root;

	while(*where != NULL && strcmp(keyname,(*where)->prez) != 0)
	{
		*whereprev = *where;
		if(strcmp(keyname,(*where)->prez)<0)
			*where = (*where)->left;
		else
			*where = (*where)->right;
	}
	*found = *where != NULL;

}
/* inserts a node into the binary tree where it should go */
void insert(tref *root, prezname keyname)
{
	int found;
	tref where, whereprev, newnode;

	searchfnc(*root, keyname, &found, &where, &whereprev);

	if(found)
		printf("sorry, name %s already found",keyname);
	else
	{
		newnode = (tref)malloc(sizeof(tnode));
		strcpy(newnode->prez, keyname);
		if(whereprev == NULL)
			*root = newnode;
		else if(strcmp(keyname, whereprev->prez) < 0)
			whereprev->left = newnode;
		else
			whereprev->right = newnode;

		newnode->left = NULL;
		newnode->right = NULL;

	}
}

void lnr(tref root)
{

	if(root != NULL)
	{

		lnr(root->left);
		strcpy(pres[n],root->prez);
		n++;
		lnr(root->right);
	
	}


}
/* recursive algorithm to balance the binary tree */
void balance(int lft, int rght, tref *root)
{
	int mid;
	if(lft>rght)
		*root = NULL;
	else
	{
		mid = (lft + rght)/2;
		*root = (tref)malloc(sizeof(tnode));
		strcpy((*root)->prez, pres[mid]);
		balance(lft,mid-1,&((*root)->left));
		balance(mid+1,rght,&((*root)->right));
	}
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
		fprintf(outptr,"\n\n\n");
		nlr(root->left);
		nlr(root->right);
	}
}


