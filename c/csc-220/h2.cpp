/* ////////////////////////////////////////////////////////////////////////
   NAME: Dindo Liboon
   DATE: July 17, 2001
PROJECT: Homework #2, CSC-220-01
PURPOSE: Determine if a positive integer that is 4 to 10 digits in length
         can be divisible by a variety of numbers.
COMPILE: cxx h2.cpp
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */

#include <fstream.h>
#include "h2.h"

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: 0 for success
PURPOSE: Core application code that will open the data file and read any
         amount of integers into a buffer stored in the clsdiv class.
         Integers will be tested for divisibility for certain numbers.
         Results for each integer will be shown on the screen.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int main()
{
    ifstream fpDataIn;
    clsdiv   div;

    /* read data file until EOF */
    fpDataIn.open("h2data");
    while (!fpDataIn.eof() && fpDataIn >> div.chBuffer)
    {
        /* check for end of integer */
        if (div.chBuffer == '.')
        {
            /* check if array has items */
            if (div.length())
            {
                div.printdiv();
                div.reset();
            }
        }
        else
        {
            /* set the next array item */
            div.set();
        }
    }
    fpDataIn.close();

    /* quit program successfully */
    return 0;
}

/* ////////////////////////////////////////////////////////////////////////
                                END OF CODE
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
