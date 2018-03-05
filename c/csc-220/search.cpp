/* ////////////////////////////////////////////////////////////////////////
   NAME: Dindo Liboon
   DATE: June 13th, 2001
PROJECT: Sample #1, CSC-220-01
PURPOSE: A collection of algorithms for searching ordered and unordered
         arrays. Tested for integers only.
COMPILE: cxx search.cpp
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */

#include <iostream.h>

void doswap(int *, int *);
int sequential(int *, int,  int);
int sentinel(int *, int,  int);
int probability(int *, int, int);
int orderedlist(int *, int, int);
int binary(int *, int, int);

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: none
PURPOSE: Main application code.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int main()
{
	/* leave space for 1 temporary element */
	/* extra space is only used in the sentinel search */
	int u[12]   = {4, 21, 36, 14, 62, 91, 8, 22, 7, 81, 77};
	int o[12]   = {4, 7, 8, 14, 21, 22, 36, 62, 77, 81, 91};

        int iTarget = -1;
        int iFound  = -1;

	/* ask for integer input */
	cout << "Integer to find: ";
	cin  >> iTarget;

	/* sequential unordered search */
	cout << "Sequential Search for " << iTarget << " was ";
        iFound = sequential(u, sizeof(u) - sizeof(int), iTarget);
	if (iFound == -1)
		cout << "not found.\n";
	else
		cout << "found at position " << iFound << ".\n";

	/* sentinel unordered search */
	cout << "Sentinel Search for " << iTarget << " was ";
        iFound = sentinel(u, sizeof(u), iTarget);
	if (iFound == -1)
		cout << "not found.\n";
	else
		cout << "found at position " << iFound << ".\n";

	/* probability ordered search */
	cout << "Probability Search for " << iTarget << " was ";
        iFound = probability(o, sizeof(o) - sizeof(int), iTarget);
	if (iFound == -1)
		cout << "not found.\n";
	else
		cout << "found at position " << iFound << ".\n";

	/* ordered-list search */
	cout << "Ordered-List Search for " << iTarget << " was ";
        iFound = orderedlist(o, sizeof(o) - sizeof(int), iTarget);
	if (iFound == -1)
		cout << "not found.\n";
	else
		cout << "found at position " << iFound << ".\n";

	/* binary ordered search */
	cout << "Binary Search for " << iTarget << " was ";
        iFound = binary(o, sizeof(o) - sizeof(int), iTarget);
	if (iFound == -1)
		cout << "not found.\n";
	else
		cout << "found at position " << iFound << ".\n";

	return 0;
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: pointer to array element, pointer to array element
 OUTPUT: none
PURPOSE: Switches the values of one element with another element.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
void doswap(int *iX, int *iY)
{
    int iTmp;

    if (*iX < *iY)
    {
        iTmp = *iX;
        *iX  = *iY;
        *iY  = iTmp;
    }
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: pointer to array, size of array, number to find
 OUTPUT: position of number (-1 if not found)
PURPOSE: Searches an array of integers for a specific number. Stops when
         the number is found or it reaches the end of the array.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int sequential(int * iArrayPtr, int iArraySz, int iTarget)
{
	int iIntSz   = sizeof(int);
	int iArrayMx = (iArraySz / iIntSz) - 1;

	for (int iCnt = 0; iCnt <= iArrayMx; iCnt++)
		if (iTarget == iArrayPtr[iCnt])
			return iCnt;

	return -1;
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: pointer to array, size of array, number to find
 OUTPUT: position of number (-1 if not found)
PURPOSE: Searches an array of integers for a specific number. Stops when
         the number is found or when it reaches the sentinel value.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int sentinel(int * iArrayPtr, int iArraySz, int iTarget)
{
	int iIntSz   = sizeof(int);
	int iArrayMx = (iArraySz / iIntSz) - 1;
	int iCnt     = 0;

        iArrayPtr[iArrayMx] = iTarget;

	for (;;)
	{
		if (iTarget == iArrayPtr[iCnt])
			break;
		++iCnt;
	}

	if (iCnt == iArrayMx)
		return -1;
	else
		return iCnt;
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: pointer to array, size of array, number to find
 OUTPUT: position of number (-1 if not found)
PURPOSE: Searches an array of integers for a specific number. When the
         number is found, it is swapped with the previous element, unless
         it is already the highest element (0).
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int probability(int * iArrayPtr, int iArraySz, int iTarget)
{
	int iIntSz   = sizeof(int);
	int iArrayMx = (iArraySz / iIntSz) - 1;

	for (int iCnt = 0; iCnt <= iArrayMx; iCnt++)
		if (iTarget == iArrayPtr[iCnt])
			if (iCnt > 0)
			{
				doswap(&iArrayPtr[iCnt], &iArrayPtr[iCnt - 1]);
				return iCnt - 1;
			}
			else
				return iCnt;
	return -1;
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: pointer to array, size of array, number to find
 OUTPUT: position of number (-1 if not found)
PURPOSE: Searches an array of integers for a specific number. Checks if
         the highest number is less than the target. If so, then the
         number is not within range.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int orderedlist(int * iArrayPtr, int iArraySz, int iTarget)
{
	int iIntSz   = sizeof(int);
	int iArrayMx = (iArraySz / iIntSz) - 1;

	if (iArrayPtr[iArrayMx] < iTarget) return -1;

	for (int iCnt = 0; iCnt <= iArrayMx; iCnt++)
		if (iTarget == iArrayPtr[iCnt])
			return iCnt;

	return -1;
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: pointer to array, size of array, number to find
 OUTPUT: position of number (-1 if not found)
PURPOSE: Searches an array of integers for a specific number. Divides the
         array into two sections (high and low). The middle (or pivot) is
         used as a marker to determine which area to search.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int binary(int * iArrayPtr, int iArraySz, int iTarget)
{
	int iIntSz   = sizeof(int);
	int iArrayLw = 0;
	int iArrayMx = (iArraySz / iIntSz) - 1;
	int iArrayMd;

	while (iArrayLw <= iArrayMx)
	{
		iArrayMd = (iArrayLw + iArrayMx) / 2;

		if (iArrayPtr[iArrayMd] == iTarget)
			return iArrayMd;
		else if (iArrayPtr[iArrayMd] < iTarget)
			iArrayLw = iArrayMd + 1;
		else
			iArrayMx = iArrayMd - 1;
	}

	return -1;
}

/* ////////////////////////////////////////////////////////////////////////
                               END OF PROGRAM
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
