//   ,,,
// ;;;´´;,
//;;´   ;;
//;´    ;; , ,    ,,,    ,,,,
//;    ,,, ;;;;  ;;´;;  ;;´;;
//; ´´´´;; ;;´  ;;,,;; ;;´ ;;
//;,   ,;´ ;;   ;;´´´´ ;; ,;;
//;;,,;;´  ;;   ;;,,;; ´;;´;;
//  ´´´    ´´     ´´   ,,  ;;
//                      ´;;;´
//
//                              ,,
//;;;   ,;;,                    ;;     ,,
//;;;,  ;;;;                    ;;     ;;
//;;;; ,;;;;  ,,,   , ,   ;;,,, ;; ,,  ,,   ,,,
//;;´; ;;´;; ,;;´;, ;;;; ,;;´´;;;;;´;; ;;  ;;´;;
//;; ;;;; ;; ;;  ;; ;;´  ´;;  ;;;;; ;; ;;  ;;,´´
//;;  ;;  ;; ;;  ;; ;;    ;; ,;´;;  ;; ;;   ´;;,
//;;      ;; ;;,;;´ ;;    ;;,;´ ;;  ;; ;;  ;;,;;
//´´      ´´   ´´´  ´´    ;;´´  ´´  ´´ ´´   ´´´
//                        ;;
//
// Heap sort is one of the fastest sorting algorithms
// on average it can be the fastest. Mainly used for
// sorting huge lists of 1,000,000 + items.
//

#include<stdio.h>
#include<string.h>
#include<math.h>
#include<stdlib.h>

typedef char prezname[25];
prezname pres[50];
prezname keyname;
int n = 1;
FILE *inptr, *outptr;

void heap_sort(prezname pres[]);
void sift(prezname pres[],int J, int N);
char* myFunc(void);

void main(void)
{

	int i;
	char* my_Name;
	inptr = fopen("prez.txt","r");
	outptr = fopen("outfile.txt","w");
	while(fscanf(inptr, "%s", keyname) != EOF)
	{
		strcpy(pres[n],keyname);
		n++;
	}
	for(i = 0; i < n;i++)
		fprintf(outptr,"%s\n",pres[i]);
    (char*)my_Name = myFunc();
	fprintf(outptr,"\n\n==sorted by %s==\n\n",my_Name);

	heap_sort(pres);	

	for(i = 0; i < n;i++)
		fprintf(outptr,"%s\n",pres[i]);
}
    
void heap_sort(prezname pres[])
{
	int N = n; // N is copy of n allowing us to decrement and 
	           // 'prune' the tree //
	int J = 0;
	prezname temp;
	for (J = N/2; J > 0; J--)
	    sift(pres, J, N);
	do
	{
        strcpy(temp,pres[0]);
        strcpy(pres[0],pres[N - 1]);
        strcpy(pres[N - 1], temp);
        N-- ; // pruning //
        sift(pres, 1, N);

	} while (N > 1);
}    

char* myFunc(void)
{
char* someStr;
someStr = "Greg Morphis";
return someStr;
} 

void sift(prezname pres[], int J, int N) 
{
	prezname temp;
	strcpy(temp, pres[J - 1]);
	while (J <= N/2) // while present root has nodes //
	{
       int j = J + J;
       if ((j < N) && (strcmp(pres[j - 1],pres[j])<0))
	      j++;
	   if (strcmp(temp,pres[j - 1]) >= 0)
          break;
       else
	   {
          strcpy(pres[J - 1],pres[j - 1]);
          J = j;
	   }
	
	}
    strcpy(pres[J - 1], temp);
}




    
	
