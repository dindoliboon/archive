/* ////////////////////////////////////////////////////////////////////////
   NAME: Dindo Liboon
   DATE: July 17, 2001
PROJECT: Homework #2, CSC-220-01
PURPOSE: Determine if a positive integer that is 4 to 10 digits in length
         can be divisible by a variety of numbers.
COMPILE: cxx h2.cpp
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */

#include <iostream.h>

class clsdiv
{
public:
    friend ostream & operator<<(ostream &, clsdiv &);

    clsdiv();
    void reset();
    void set();
    void printdiv();
    int  length();
    char chBuffer;

private:
    int check(int, int);
    int truenum();
    int samerule(int, int, int, int, int);
    int by2();
    int by3();
    int by4();
    int by5();
    int by6();
    int by7();
    int by8();
    int by9();
    int by10();
    int by11();
    int by12();
    int by13();
    int by17();
    int by19();
    int by23();
    int places(int);
    int rgiBuffer[10];
    int iLength;
};

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: none
PURPOSE: Constructor for clsdiv. Makes sure that the array and length
         are zero.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
clsdiv::clsdiv()
{
    reset();
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: none
PURPOSE: Makes all elements in the array empty and sets the array length
         back to zero.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
void clsdiv::reset()
{
    for(int iCnt = 0; iCnt <= 10; iCnt++)
    {
        rgiBuffer[iCnt] = NULL;
        iLength = 0;
    }
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: integer or character containing an ASCII number value
 OUTPUT: none
PURPOSE: Sets an array element and resizes the array.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
void clsdiv::set()
{
    /* item numbers are subtracted by 48 */
    /* because 48 represents 0 in ASCII  */
    rgiBuffer[iLength] = chBuffer - 48;
    iLength++;
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: length of number
PURPOSE: Returns the length of the array.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int clsdiv::length()
{
    if (iLength == 0) return 0;

    return iLength - 1;
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: returns 1 if divisible, 0 if not
PURPOSE: Checks if a number is divisible by 2.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int clsdiv::by2()
{
    if (rgiBuffer[length()] == 0 || rgiBuffer[length()] == 2 ||
        rgiBuffer[length()] == 4 || rgiBuffer[length()] == 6 ||
        rgiBuffer[length()] == 8)
        return 1;

    return 0;
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: returns 1 if divisible, 0 if not
PURPOSE: Checks if a number is divisible by 3.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int clsdiv::by3()
{
    int iTmp = 0;

    /* get sum of numbers */
    for(int iCnt = 0; iCnt <= length(); iCnt++)
        iTmp += rgiBuffer[iCnt];

    return check(iTmp, 3);
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: returns 1 if divisible, 0 if not
PURPOSE: Checks if a number is divisible by 4.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int clsdiv::by4()
{
    int iTmp = 10;

    /* create last two digits */
    iTmp *= rgiBuffer[length() - 1];
    iTmp += rgiBuffer[length()];

    return check(iTmp, 4);
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: returns 1 if divisible, 0 if not
PURPOSE: Checks if a number is divisible by 5.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int clsdiv::by5()
{
    if (rgiBuffer[length()] == 0 || rgiBuffer[length()] == 5)
        return 1;

    return 0;
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: returns 1 if divisible, 0 if not
PURPOSE: Checks if a number is divisible by 6.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int clsdiv::by6()
{
    /* check if divisible by 2 & 3 */
    if (by2() && by3())
        return 1;

    return 0;
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: returns 1 if divisible, 0 if not
PURPOSE: Checks if a number is divisible by 7.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int clsdiv::by7()
{
    // number, remaining, multiplier, rest, 0 subtract
    return samerule(7, 10, 2, 10, 0);
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: returns 1 if divisible, 0 if not
PURPOSE: Checks if a number is divisible by 8.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int clsdiv::by8()
{
    int iTen = 10;
    int iHnd = 100;
    int iTmp = 0;

    /* create last three digits */
    iTen *= rgiBuffer[length() - 1];
    iHnd *= rgiBuffer[length() - 2];
    iTmp += rgiBuffer[length()] + iTen + iHnd;

    return check(iTmp, 8);
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: returns 1 if divisible, 0 if not
PURPOSE: Checks if a number is divisible by 9.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int clsdiv::by9()
{
    int iTmp = 0;

    /* get sum of numbers */
    for(int iCnt = 0; iCnt <= length(); iCnt++)
        iTmp += rgiBuffer[iCnt];

    return check(iTmp, 9);
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: returns 1 if divisible, 0 if not
PURPOSE: Checks if a number is divisible by 10.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int clsdiv::by10()
{
     /* check if last number is 0 */
    if (rgiBuffer[length()] == 0)
        return 1;

    return 0;
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: returns 1 if divisible, 0 if not
PURPOSE: Checks if a number is divisible by 11.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int clsdiv::by11()
{
    int iTmp = 0;

    /* go through each integer, making each odd */
    /* number negative, then add them together  */
    for(int iCnt = 0; iCnt <= length(); iCnt++)
    {
        /* multiply odd numbers by -1 */
        if (iCnt % 2 == 1)
            iTmp += (rgiBuffer[iCnt] * -1);
        else
            iTmp += rgiBuffer[iCnt];
    }

    /* check if sum is 0 or 11 */
    if (iTmp == 0 || iTmp == 11)
        return 1;

    return 0;
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: returns 1 if divisible, 0 if not
PURPOSE: Checks if a number is divisible by 12.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int clsdiv::by12()
{
    /* check if divisible by 3 & 4 */
    if (by3() && by4())
        return 1;

    return 0;
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: returns 1 if divisible, 0 if not
PURPOSE: Checks if a number is divisible by 13.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int clsdiv::by13()
{
    // number, remaining, multiplier, rest, 1 add
    return samerule(13, 10, 4, 10, 1);
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: returns 1 if divisible, 0 if not
PURPOSE: Checks if a number is divisible by 17.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int clsdiv::by17()
{
    // number, remaining, multiplier, rest, 0 subtract
    return samerule(17, 10, 5, 10, 0);
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: returns 1 if divisible, 0 if not
PURPOSE: Checks if a number is divisible by 19.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int clsdiv::by19()
{
    // number, remaining, multiplier, rest, 1 add
    return samerule(19, 10, 2, 10, 1);
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: returns 1 if divisible, 0 if not
PURPOSE: Checks if a number is divisible by 23.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int clsdiv::by23()
{
    // number, remaining, multiplier, rest, 1 add
    return samerule(23, 100, 3, 10, 1);
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: int iNumber, int iRest, int iMul, int iEnd, iAdd
 OUTPUT: returns 1 if divisible, 0 if not
PURPOSE: Checks if a number is divisible by a certain number. This is for
         rules that use the same format.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int clsdiv::samerule(int iNumber, int iRest, int iMul, int iEnd, int iAdd)
{
    int x = truenum();
    int y = 9; // give program 10 tries

    while (y)
    {
        // seprate number and apply formula
        if (iAdd == 1)
            x = (x / iRest) + (iMul * (x - ((x / iEnd) * iEnd)));
        else
            x = (x / iRest) - (iMul * (x - ((x / iEnd) * iEnd)));

        // return absolute value
        if (x < 0) x = -x;

        // exit loop if equal to iNumber
        if (x == iNumber || x == 0)
            break;

        // decrease counter
        --y;
    }

    return check(truenum(), iNumber);
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: none
PURPOSE: Prints a number's divisibility.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
void clsdiv::printdiv()
{
    cout << *this
         << " ->"
         << ((by2())  ? " 2"  : "")
         << ((by3())  ? " 3"  : "")
         << ((by4())  ? " 4"  : "")
         << ((by5())  ? " 5"  : "")
         << ((by6())  ? " 6"  : "")
         << ((by7())  ? " 7"  : "")
         << ((by8())  ? " 8"  : "")
         << ((by9())  ? " 9"  : "")
         << ((by10()) ? " 10" : "")
         << ((by11()) ? " 11" : "")
         << ((by12()) ? " 12" : "")
         << ((by13()) ? " 13" : "")
         << ((by17()) ? " 17" : "")
         << ((by19()) ? " 19" : "")
         << ((by23()) ? " 23" : "")
         << endl;
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: number to be divided, number that divides
 OUTPUT: returns 1 if divisible, 0 if not
PURPOSE: Checks if a number is divisible by another number.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int clsdiv::check(int iTmp, int iDivisor)
{
    if ((iTmp % iDivisor) == 0)
        return 1;

    return 0;
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: integer value stored in rgiBuffer
PURPOSE: Returns the true integer value of the elements stored in the
         rgiBuffer array.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int clsdiv::truenum()
{
    int iTmp = 0;

    for(int iCnt = 0; iCnt <= length(); iCnt++)
        iTmp += rgiBuffer[iCnt] * places(length() - iCnt);

    return iTmp;
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: integer to placement amount
 OUTPUT: placement * 10
PURPOSE: Determines a certain placement value.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int clsdiv::places(int iPlaces)
{
    int iTmp = 10;

    /* return placement value */
    if (iPlaces == 0) return 1;
    for(int iCnt = 0; iCnt < iPlaces - 1; iCnt++)
        iTmp *= 10;

    return iTmp;
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: address of ostream, address of clsdiv
 OUTPUT: output stream
PURPOSE: Allows clsdiv to be displayed as a number in an output stream.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
ostream & operator<<(ostream &sOutput, clsdiv &tmp)
{
    for(int iCnt = 0; iCnt <= tmp.length(); iCnt++)
        sOutput << tmp.rgiBuffer[iCnt];

    return sOutput;
}

/* ////////////////////////////////////////////////////////////////////////
                                END OF CODE
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
