// February 24, 2001
// CSC-130, Program 3

#include <fstream.h>
#include <iostream.h>
#include <string.h>
#include <iomanip.h>

typedef struct _StdRecords
{
    char lname[21];
    char fname[11];
    char mi;
    int  test1;
    int  test2;
    int  test3;
    int  final;
    int  total;
    char grade;
} stdRecords;

stdRecords csc100[25];
stdRecords csc120[20];
stdRecords csc130[15];

int ReadRecords(stdRecords *, char *);
void swap(char *, char *);
void swap(int *, int *);
void sort(stdRecords *, int, int);
void display(stdRecords *, int);
void DisplayRecords(stdRecords *, char *, char *, int);
void SwapData(stdRecords *, int, int);

int main()
{
    // displays last names in alphabetical order
    DisplayRecords(csc100, "CSC-100", "csc100.dat", 0);
    DisplayRecords(csc120, "CSC-120", "csc120.dat", 0);
    DisplayRecords(csc130, "CSC-130", "csc130.dat", 0);

    // displays total scores in decending order
    DisplayRecords(csc100, "CSC-100", "csc100.dat", 1);
    DisplayRecords(csc120, "CSC-120", "csc120.dat", 1);
    DisplayRecords(csc130, "CSC-130", "csc130.dat", 1);

    return 0;
}

int ReadRecords(stdRecords *recName, char *fileName)
{
    ifstream fp1;
    int i = 0;

    fp1.open(fileName);
    while(!fp1.eof() && fp1 >> recName[i].lname)    // read last name
    {
        fp1.ignore(1);                              // ingore space
        fp1 >> recName[i].fname;                    // read first name
        fp1.ignore(1);                              // ingore space
        fp1 >> recName[i].mi;                       // read middle inital
        fp1.ignore(1);                              // ingore period
        fp1 >> recName[i].test1                     // read test grades
            >> recName[i].test2
            >> recName[i].test3
            >> recName[i].final;
        fp1.ignore(1);                              // ingore <lf>

        // calculate total
        recName[i].total = recName[i].test1 + recName[i].test2 +
                           recName[i].test3 + recName[i].final;

        // determine letter grade
        if (recName[i].total >= 450)
            recName[i].grade = 'A';
        else if (recName[i].total >= 400)
            recName[i].grade = 'B';
        else if (recName[i].total >= 350)
            recName[i].grade = 'C';
        else if (recName[i].total >= 300)
            recName[i].grade = 'D';
        else 
            recName[i].grade = 'F';

        // remove comma
        recName[i].lname[strlen(recName[i].lname) - 1] = NULL;

        // increment record
        i++;
    }
    fp1.close();

    // return number of records found
    return i;
}

void sort(stdRecords *recName, int i, int type)
{
    for (int x = 0; x < (i - 1); x++)
        for (int y = (x + 1); y < i; y++)
            switch (type)
            {
                case 0:
                {
                    if (strcmp(recName[x].lname, recName[y].lname) > 0)
                        SwapData(recName, x, y);
                    break;
                }
                case 1:
                {
                    if (recName[x].total < recName[y].total)
                       SwapData(recName, x, y);
                    break;
                }
            }
}

void swap(char *x, char *y)
{
    char tmp[21];

    strcpy(tmp, x);
    strcpy(x, y);
    strcpy(y, tmp);
}

void swap(int *x, int *y)
{
    int tmp;

    tmp = *x;
    *x = *y;
    *y = tmp;
}

void display(stdRecords *recName, int i)
{
    for (int x = 0; x < i; x ++)
        cout << setiosflags(ios::left)<< setw(2) << x + 1 << setw(2) << ">"
             << setw(21)<< recName[x].lname << setw(11) << recName[x].fname
             << recName[x].mi << " " << setw(4)  << recName[x].test1
             << setw(4) << recName[x].test2 << setw(4)  << recName[x].test3
             << setw(4) << recName[x].final << setw(4)  << recName[x].total
             << setw(1) << recName[x].grade << endl;
}

void DisplayRecords(stdRecords *recName, char *title, char *fileName, int SortBy)
{
    int recCount = ReadRecords(recName, fileName);
    sort(recName, recCount, SortBy);
    cout << "\n" << "******************** "
         << title << "  Roster **********************\n";
    cout << "No  Last                 First      M T1  T2  T3  Fnl Tol G\n";
    cout << "***********************************************************\n";
    display(recName, recCount);
}

void SwapData(stdRecords *recName, int x, int y)
{
    swap(recName[x].lname, recName[y].lname);
    swap(recName[x].fname, recName[y].fname);
    swap(&recName[x].mi, &recName[y].mi);
    swap(&recName[x].grade, &recName[y].grade);
    swap(&recName[x].test1, &recName[y].test1);
    swap(&recName[x].test2, &recName[y].test2);
    swap(&recName[x].test3, &recName[y].test3);
    swap(&recName[x].final, &recName[y].final);
    swap(&recName[x].total, &recName[y].total);
}
                                                                                                                                                          