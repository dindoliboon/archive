
#include <stdio.h>
#include "VBlib.h"

void main()
{

   char  *StartString=" Rock the casbah   ";
   char  *szSearchString="the";

   printf("Demonstration of VB String Functions for C\n\n"
          "  Original String:\t\t\t\t\"%s\"\n\n"
          "  ------------------------------------------------------------------------\n\n", StartString);

   printf("  len:   Length of string\t\t\t%i\n", len(StartString));
   printf("  instr: Position of string \"%s\" \t\t%i\n", szSearchString, instr(0, StartString, szSearchString));
   printf("  right: 9 last characters\t\t\t\"%s\"\n", right(StartString, 9));   
   printf("  left:  First 5 characters\t\t\t\"%s\"\n", left(StartString, 5));    
   printf("  ltrim: Remove leading spaces\t\t\t\"%s\"\n", ltrim(StartString) );
   printf("  rtrim: Remove trailing spaces\t\t\t\"%s\"\n", rtrim(StartString) );
   printf("  trim:  Remove leading and trailing spaces\t\"%s\"\n", trim(StartString) );
   printf("  mid:   6 characters, with an offset of 11\t\"%s\"\n\n", mid(StartString, 11, 6));    

   printf("  ------------------------------------------------------------------------\n\n"
          "  See VBlib.h for more information.\n\n"
          "  mail:    afawcett@u.washington.edu\n"
          "  web:     http://www.disoriented.com/labs/\n\n");
}
