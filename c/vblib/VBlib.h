/*

   VBlib - Visual Basic String Functions for C

   Website: http://www.disoriented.com/labs/
   Date:    September 24, 2000

   ---

   VBlib contains C ports of the Visual Basic string manipulation functions.
   Included are C versions of:

      len
      instr
      right
      left
      ltrim
      rtrim
      trim
      mid

   Read the comments above each function for more information. Except where
   noted, most functions can be used in a similar way to their VB counterparts.

   We've successfully compiled this on Windows 2000 and AIX 4.2. It should be
   portable to any version of Unix or Windows.

   ---

   License

   (This license is borrowed from zLib.)

   This software is provided 'as-is', without any express or implied warranty. 
   In no event will the author(s) be held liable for any damages arising from
   the use of this software. Permission is granted to anyone to use this
   software for any purpose, including commercial applications, and to alter
   it and redistribute it freely, subject to the following restrictions:

   1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software in
   a product, an acknowledgment in the product documentation would be
   appreciated but is not required.

   2. Altered source versions must be plainly marked as such, and must not
   be misrepresented as being the original software.

   3. This notice may not be removed or altered from any source distribution.

   Enjoy.



   Code Copyright (C) 2000 Andrew Fawcett (afawcett@u.washington.edu)
 
   ---

   Revision History

      v1.0        September 24, 2000         Initial Release

*/


#ifdef _WIN32
   #include <windows.h>
#endif // _Win32

#include <stdio.h>

#ifndef VBLIB_H
#define VBLIB_H

   #define  Len      len
   #define  Instr    instr
   #define  InStr    instr
   #define  Right    right
   #define  Left     left
   #define  Ltrim    ltrim
   #define  LTrim    ltrim
   #define  Rtrim    rtrim
   #define  RTrim    rtrim
   #define  Mid      mid

   #define TRUE   1
   #define FALSE  0

   char *mid( char *c, int offset, int len );   
   char *trim( char *in );
   char *left( char *in, int size );
   char *right( char *in, int size );
   char *ltrim( char *in );
   char *rtrim( char *in );
   
   int len(char *s);
   int instr( int offset, char *src, char *query);

   int IsSpace(int in);
   int IsDigit(int in);

#endif // VBLIB_H