#include<stdio.h>
#include<string.h>
#include<math.h>
#include<stdio.h>

typedef char prezname[25];
typedef struct cell *tref;
typedef struct cell
{
	prezname prez;
	tref left;
	tref right;
}tnode;

FILE *inptr, *outptr;

void insert(tref *root, prezname keyname);
void searchfnc(tref root, prezname keyname, int *found, tref *where, tref *whereprev);
void balance(int lft, int rght, tref *root);
void nlr(tref root);

int main(void)
{
	tref root;
	prezname keyname;

	root = NULL;

	inptr = fopen("prez.txt","r");
	outptr = fopen("outfile.txt","w");

	while(fscanf(inptr, "%s", keyname) != EOF)
		insert(&root, keyname);
	return 0;

}

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
