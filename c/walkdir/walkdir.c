/* /////////////////////////////////////////////////////////////////////////

  Directory Walker Library 1.1
 
  Functions for the Directory Walker library.

  Functions:
    WalkDir
    Backslash

  History (Legend: > Info, ! Fix, + New, - Removed):
    1.0          8/26/2001   > Initial release.
    1.1          9/29/2001   + No recursion option.
 
  Author:
    DL (dl@tks.cjb.net / http://tks.cjb.net)

  /////////////////////////////////////////////////////////////////////// */

#include <windows.h>
#include <stdio.h>
#include "walkdir.h"

/* -------------------------------------------------------------------------

  Adds a backslash to a file path.

  Arguments:
    szPath  Path name to append backslash to.
 
  Return Value:
    Path name with backslash.

  ----------------------------------------------------------------------- */
char *Backslash(char *szPath)
{
  char szSlash[2] = {92, 0};

  // If backslash does not exist, add it
  if (szPath[strlen(szPath) - 1] != 92)
    return lstrcat(szPath, szSlash);

  // Nothing was done, return original string
  return szPath;
}

/* -------------------------------------------------------------------------

  Recurses a directory, redirecting information to WalkResult callback.

  Arguments:
    szPath$     Path to search.
    szSpec$     File spec. to search for.
    bRecurse    If TRUE, recursion is enabled, otherwise it is disabled.
    WalkResult  Callback function.

  Comments:
    WalkDir does not return any values, however, it passes several
    values to the callback function WalkResult.

    szPath$  Directory of current file.
    szFile$  Current file being processed.
    bFile    If TRUE, szPath$ will contain the directory of the file and
             szFile$ will contain the name of the file. Otherwise, szPath$
             will contain the sub-directory and szFile$ will be empty.

  ----------------------------------------------------------------------- */
extern void WalkDir(char *szPath, char *szSpec, int bRecurse,
  void WalkResult(char *szTPath, char *szFPath, int bType))
{
  // This kept crashing if I didn't declare it this way ...
  WIN32_FIND_DATA fd;
  HANDLE          hFind;
  char            szTmp[2048];

  // Grab file names based on file spec
  // Directories will be grabbed later
  sprintf(szTmp, "%s%s", Backslash(szPath), szSpec);

  hFind = FindFirstFile(szTmp, &fd);
  if(hFind != INVALID_HANDLE_VALUE)
  {
    for(;;)
    {
      // Make sure it is really a file
      if ((fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) == 0)
      {
        // Redirect data to WalkResult procedure
        // TRUE means a FILE was found
        WalkResult(Backslash(szPath), fd.cFileName, TRUE);
      }
      // Check if there are any files left to process
      if (FindNextFile(hFind, &fd) == 0)
      {
        break;
      }
    }
  }
  FindClose(hFind);

  // Exit if recurse is disabled
  if (!bRecurse) return;

  // Search for sub-directories
  sprintf(szTmp, "%s%s", Backslash(szPath), "*.*");
  hFind = FindFirstFile(szTmp, &fd);

  if (hFind != INVALID_HANDLE_VALUE)
  {
    for(;;)
    {
      // Make sure it is really a directory
      if ((fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)>0)
      {
        if (strcmp(fd.cFileName, ".") != 0 &&
          strcmp(fd.cFileName, "..")  != 0 &&
          strcmp(fd.cFileName, "")    != 0)
        {
          // Create new sub-directory path
          sprintf(szTmp, "%s%s", Backslash(szPath), fd.cFileName);

          // Redirect data to WalkResult procedure
          // FALSE means a DIRECTORY was found
          WalkResult(szTmp, "", FALSE);

          // Scan sub-directory
          WalkDir(szTmp, szSpec, TRUE, WalkResult);
        }
      }

      // Check if there are any directories left to process
      if (FindNextFile(hFind, &fd) == 0) break;
    }
  }

  FindClose(hFind);
}
