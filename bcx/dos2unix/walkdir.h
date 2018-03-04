/* /////////////////////////////////////////////////////////////////////////

  Directory Walker Library 1.1
 
  Contains exported functions from the Directory Walker library.

  History (Legend: > Info, ! Fix, + New, - Removed):
    1.0          8/26/2001   > Initial release.
    1.1          9/29/2001   + No recursion option.
 
  Author:
    DL (dl@tks.cjb.net / http://tks.cjb.net)

  /////////////////////////////////////////////////////////////////////// */

/* -------------------------------------------------------------------------

  walkdir.c

  ----------------------------------------------------------------------- */
extern char *Backslash(char *);
extern void WalkDir(char *, char *, int,
  void WalkResult(char *, char *, int));
