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


#include "VBlib.h"




/*

   left
   
   Returns the first #size# characters of string (in). Identical to the VB 
   version.

*/
char *left( char *in, int size )
{
   int i;
   char *buf2=(char *)malloc( size * sizeof( char ) );

   for( i=0; i<size && in[i]!='\0' ; i++) buf2[i]=in[i];
   buf2[i++]='\0';

   return buf2;
}


/*

   right

   Returns the last #size# characters of string (in). Identical to the VB 
   version.

*/
char *right( char *in, int size )
{
   char *p=in;

   int tl = len( in ) ;

   size = tl - size;

   while( *p && size > 0)
   {
      p++;
      size--;
   }

   return p;
}


/*

  mid

  Returns a substring of string c with a specified offset and length. Basically,
  an offset followed by a left().

  Identical to VB version, except that the third paramter is required. (It is
  optional in VB.)

*/
char *mid(char *c, int offset, int len)
{
   char *p=c;
   
   while( offset-1 > 0)
   {
      *p++;
      --offset;
   }
   return left(p, len);
}


/*

   ltrim (Left Trim)

   Removes any leading spaces from a given string (c). Identical to the VB
   version.

*/
char *ltrim(char *in)
{
   char *buf=in;

   for ( NULL; *buf && IsSpace(*buf); buf++);
   return buf;
}


/*

   rtrim (Right Trim)

   Removes any trailing spaces from string c. Identical to the VB version.

*/
char *rtrim(char *in)
{
   int i=len(in);

   if (in) while (--i >= 0) if ( !IsSpace(in[i]) ) break;

   return left(in, ++i);
}


/*

   trim

   Removes all leading and trailing spaces from a given string (c). Identical to
   the VB version.

*/
char *trim( char *in )
{
   in = ltrim(in);
   return rtrim(in);
}


/*

   instr (InString)

   Returns the first position of a string (query) inside another string (src).
   
   Identical to the VB version except that this version is case sensitive, and
   can only perform a texural comparison. (VB's instr offers an optional fourth
   parameter which can specify a binary comparison.)

*/
int instr( int offset, char *src, char *query)
{
   char *s1, *s2;

   int c;

   if ( !*query ) return 0;
   if ( offset > len(src) ) return 0;
   if ( offset < 0 ) offset = 0;

   c=offset;

   while ( c > 0 )
   {
      src++;
      c--;
   }

   while (*src)
   {
      s1 = src;
      s2 = (char *)query;

      while (*s1 && *s2 && !(*s1-*s2) ) s1++, s2++;

      if (!*s2) break;
      c++;
      src++;
   }

   offset+=c+1;

   if (!*src || offset<0) return 0;

   return offset;
}


/*
   
   len

   Returns the length of a string. (Basically a wrapper for strlen.)

   This is identical to the VB version.

*/
int len(char *s)
{
   return strlen(s);
}


/*

   IsSpace
   
   Support function. This isn't meant to be useful.

*/
int IsSpace(int in)
{
   if (in == 0x20 || in >= 0x09 && in <= 0x0D) return TRUE;
   return FALSE;
}


/*

  IsDigit

  Support function. This isn't meant to be useful.

*/
int IsDigit(int in)
{
   if (in >= 0x30 && in <= 0x39 ) return TRUE;
   return FALSE;
}

