// Project 1 - Arrays for Databases //
// Due: Sept 21                     //


// include needed header files //
#include<stdio.h>
#include<string.h>
#include<math.h>
#include<stddef.h>


// global variables //
typedef char prezname[25]; // array of 25 characters to store the president's name //
prezname prez[60];         // array of 60 presidents //
int n = 42;               // working variable //
FILE *inptr, *outptr;

// function prototypes //
void binsearch(prezname keyname, int *found, int *where);
// binsearch - binary search function //
void infnc(prezname keyname);
// insert function //
void delfnc(prezname keyname);
// delete function //


void main(void)
{
	prezname keyname;
	int i = 1;
	char buffer[26];


	inptr = fopen("prez.txt", "r");
	outptr = fopen("output.txt", "w");


	while((fgets(buffer, 26, inptr)) != NULL)
	{
		keyname[i] = (char *)malloc((unsigned)strlen(buffer));
		strcpy(keyname[i],buffer);
	}


	

}

void infnc(prezname keyname)
{
	int i, found, where;
	binsearch(keyname, &found, &where);
	if(found)
		printf("keyname %s found",keyname);
	else
	{
		for(i = n; i>=where; i--)
			strcpy(prez[i+1],prez[i]);
		strcpy(prez[where], keyname);
		n++;
	}
}

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
