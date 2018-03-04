// Project 1 - Arrays for Databases //
// Due: Sept 21                     //


// include needed header files //
#include<stdio.h>
#include<string.h>
#include<math.h>
#include<stddef.h>


// global variables //
typedef char prezname[25]; // array of 25 characters to store the president's name //
prezname prez[60];         // array of 60 prezname //
typedef char choice[1];

int n = 0;               // working variable //

FILE *inptr, *outptr;

// function prototypes //
void binsearch(prezname keyname, int *found, int *where);
// binsearch - binary search function //
void infnc(prezname keyname);
// insert function //
void delfnc(prezname keyname);
// delete function //
void inputfnc(prezname keyname);
// insert function //
void srch(prezname keyname);
// search function //

void main(void)
{
	prezname keyname;
	prezname who;
	int i = 1;
	char ch, dum;
	int exit = 0;


	inptr = fopen("prez.txt", "r");  /* open prez.txt and read into buffer */
	outptr = fopen("output.txt", "w");  /* open output.txt and get ready to write to it */

	while((fscanf(inptr,"%s",keyname)!=EOF))
		inputfnc(keyname);

	for(i = 1;i <= n; i++)
		fprintf(outptr, "%s\n",prez[i]);

	printf("\n\n\n\n\n\n\n\nplease select a choice from the following\n\n\n");
	fprintf(outptr,"\n\n\nplease select from the following\n\n\n");
	printf("\ntype d at the prompt for deletion\n");
	fprintf(outptr,"\ntype d at the prompt for deletion");
	printf("\ntype i at the prompt for insertion\n");
	fprintf(outptr,"\ntype i at the prompt for insertion");
	printf("\ntype s at the prompt to search\n");
	fprintf(outptr,"\ntype s at the prompt to search");
	printf("\ntype e at the prompt to exit program\n");
	fprintf(outptr,"\ntype e at the prompt to exit program");

	while(ch != 'e')
	{


	printf("\nprompt:>");
	fprintf(outptr,"\nprompt:>");
	scanf("%c%c",&ch,&dum);
	fprintf(outptr,"%c\n",ch);
	if(ch == 'd')
	{
		printf("please enter a name to delete:");
		fprintf(outptr,"please enter a name to delete:");
		scanf("%s%c",who,&dum);
		printf("deleting keyname %s\n",who);
		fprintf(outptr,"deleting keyname %s\n",who);
		delfnc(who);
		exit == 0;
	}
	if(ch == 'i')
	{
		printf("please enter a name to insert:");
		fprintf(outptr,"please enter a name to insert:");
		scanf("%s%c",who,&dum);
		printf("inserting keyname %s\n",who);
		fprintf(outptr,"inserting keyname %s\n",who);
		infnc(who);
		exit == 0;
	}
	if(ch == 's')
	{
		printf("please enter a name to search for:");
		fprintf(outptr,"please enter a name to search for:");
		scanf("%s%c",who,&dum);
		printf("searching for keyname %s\n",who);
		fprintf(outptr,"searching for keyname %s\n",who);
		srch(who);
		exit == 0;
	}
	if(ch == 'e')
	{
		printf("bye bye\n\n");
		fprintf(outptr,"bye bye\n\n");
		exit == 1;
	}

	if(exit == 1)
		break;
}

	for(i = 1; i <= n; i++)
		fprintf(outptr,"%s\n",prez[i]);




}

void infnc(prezname keyname)
{
	int i, found, where;
	binsearch(keyname, &found, &where);
	if(found)
	{
		printf("\nkeyname %s is found\n",keyname);
		fprintf(outptr,"\nkeyname %s is found\n",keyname);
	}
	else
	{
		for(i = n; i >= where; i--)
			strcpy(prez[i+1], prez[i]);
	     strcpy(prez[where], keyname);
	     n++;
		 printf("keyname %s inserted",keyname);
		 fprintf(outptr,"keyname %s inserted",keyname);
	}

}
/***********************************************************/
/*                                                         */
/*  binary search is one of the fastest search algorithms  */
/*                                                         */
/***********************************************************/
void binsearch(prezname keyname, int *found, int *where)
{
	int top, bottom, mid;
	top = 1;
	bottom = n;
	*found = 0;
	while(top <= bottom && !(*found))
	{
		mid = (top + bottom) / 2;
		if(strcmp(keyname, prez[mid])==0)
		{
			*found = 1;
			*where = mid;
		}
		else
		{
			if(strcmp(keyname, prez[mid])>0)
				top = mid + 1;
			else
				bottom = mid - 1;
		}
	}
	if(!(*found))
		*where = top;
}

/***************************************************/
/*                  inputfnc                       */
/*   function that inputs a string into an array   */
/***************************************************/

void inputfnc(prezname keyname)
{
	int i, found, where;

	binsearch(keyname, &found, &where);
	if(!found)
	{
		for(i = n; i >= where; i--)
			strcpy(prez[i+1], prez[i]);
		strcpy(prez[where], keyname);
		n++;

	}



}
/***************************************************/
/*                   delfnc                        */
/*    delfnc deletes a string from the array       */
/***************************************************/
void delfnc(prezname keyname)
{
	int i, found, where;
	binsearch(keyname, &found, &where);
	if(!found)
	{
		printf("sorry keyname - %s could not be found\n",keyname);
		fprintf(outptr,"sorry keyname - %s could not be found\n",keyname);
	
	}
	else
	{
		strcpy(prez[where],"");
		for(i = where; i <= n;i++)
			strcpy(prez[i], prez[i+1]);
		n--;


	}
}
/**************************************************/
/*                    srch                        */
/*    srch, when passed a string will search for  */
/*      that string in the array                  */
/**************************************************/
void srch(prezname keyname)
{
	int found, where;
	binsearch(keyname,&found, &where);
	if(!found)
	{
		printf("name not found\n");
		fprintf(outptr,"name %s not found\n",keyname);
	}
	else
	{
		printf("keyname - %s found\n",keyname);
		fprintf(outptr, "keyname - %s found\n",keyname);
	}

}