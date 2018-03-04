// January 31, 2001
// CSC-130, Program 2

#include <iostream.h>
#include <fstream.h>

void ReadFile(char *, float *, int *, int, float *);
void DisplayData(char *, float *, int, float *, char *, int);
void Swap(float *, float *);
                 
int main()
{
    float gArray[60];
    float xSum;
    float fSum;
    int yCount;
    int zCount;

    // display numerical data
    DisplayData("asm2.dat.1", &xSum, yCount, gArray, "first", 1);
    fSum += xSum;
    DisplayData("asm2.dat.1", &xSum, yCount, gArray, "second", 2);
    fSum += xSum;
    DisplayData("asm2.dat.1", &xSum, yCount, gArray, "third", 3);
    fSum += xSum;

    // sort and show final array
    for (yCount = 0; yCount < 59; yCount++)
        for (zCount = yCount + 1; zCount < 60; zCount++)
            Swap(&gArray[zCount], &gArray[yCount]);

    cout << "The 60 numbers in all files in ascending order are:\n";
    for (yCount = 0; yCount < 60; yCount++)
    {
        cout << gArray[yCount] << ",  ";
        if (!((1+yCount) % 4)) cout << endl;
    }
    cout << "The sum of the 60 numbers in three data files = "
         << fSum << endl;

    return 0;
}

void ReadFile(char *lpName, float *fSum, int *iCount,
              int iType, float *fArray)
{
    ifstream FP_Data;
    float fTemp;
    int iTemp;

    iTemp = 0;
    *fSum = 0;
    FP_Data.open(lpName, ios::in);
    while(!FP_Data.eof() && FP_Data >> fTemp)
    {
        *fSum += fTemp;
        if (iType == 1) fArray[iTemp] = fTemp;
        if (iType == 2) fArray[iTemp + 20] = fTemp;
        if (iType == 3) fArray[iTemp + 40] = fTemp;
        iTemp++;
    }
    FP_Data.close();
    *iCount = iTemp;
}

void DisplayData(char *lpName, float *a, int b, float *c,
                 char *lpNumber, int z)
{
    int iCount;

    ReadFile(lpName, a, &b, z, c);
    cout << "The " << b << " numbers in "
         << lpNumber << " data file are:\n";
    for (iCount = b*(z-1); iCount < b*z; iCount ++)
    {
        cout << c[iCount] << ",  ";
        if (!((1+iCount) % 4)) cout << endl;
    }
    cout << "The sum of the " << b << " numbers in "
         << lpNumber << " data file = " << *a << endl << endl;
}

void Swap(float *j, float *i)
{
    float temp;

    if (*j < *i)
    {
        temp = *j;
        *j = *i;
        *i = temp;
    }
}
