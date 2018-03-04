TinyPTC 0.8 for BCX/LCC Revision 3
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This includes the source code to the TinyPTC libaries.

You will need LCC-Win32 to compile these static libraries
for the 3 different  modes. These modes include
DirectDraw, GDI, and Video for Windows.

The object file was compiled with NASM and is included.

Compile DirectDraw Library
~~~~~~~~~~~~~~~~~~~~~~~~~~
 1. Switch to \source\ directory
 2. Open the file tinyptc.h
 3. Uncomment the line #define __PTC_DDRAW__
 4. Comment the line #define __PTC_GDI__
 5. Comment the line #define __PTC_VFW__
 6. Go into console mode
 7. Type build.bat
 8. Copy tinyptc.lib to sample directory
 9. Copy tinyptc.h to sample directory
10. Switch to \sample\ directory
11. Type build.bat
12. Run test.exe

Compile GDI Library
~~~~~~~~~~~~~~~~~~~
 1. Switch to \source\ directory
 2. Open the file tinyptc.h
 3. Comment the line #define __PTC_DDRAW__
 4. Uncomment the line #define __PTC_GDI__
 5. Comment the line #define __PTC_VFW__
 6. Go into console mode
 7. Type build.bat
 8. Copy tinyptc.lib to sample directory
 9. Copy tinyptc.h to sample directory
10. Switch to \sample\ directory
11. Type build.bat 2
12. Run test.exe

Compile VFW Library
~~~~~~~~~~~~~~~~~~~
 1. Switch to \source\ directory
 2. Open the file tinyptc.h
 3. Comment the line #define __PTC_DDRAW__
 4. Comment the line #define __PTC_GDI__
 5. Uncomment the line #define __PTC_VFW__
 6. Go into console mode
 7. Type build.bat 3
 8. Copy tinyptc.lib to sample directory
 9. Copy tinyptc.h to sample directory
10. Switch to \sample\ directory
11. Type build.bat
12. Run test.exe

Compile Full Screen
~~~~~~~~~~~~~~~~~~~
 1. Switch to \source\ directory
 2. Open the file tinyptc.h
 3. Choose Library Mode (DirectDraw, GDI, VFW)
 4. Comment the line #define __PTC_WINDOWED__
 5. Comment the line #define __PTC_CENTER_WINDOW__
 6. Comment the line #define __PTC_RESIZE_WINDOW__
 7. Comment the line #define __PTC_WINMAIN_CRT__
 8. Uncomment the line #define __PTC_MAIN_CRT__
 9. Go into console mode
10. Type build.bat
11. Copy tinyptc.lib to sample directory
12. Copy tinyptc.h to sample directory
13. Switch to \sample\ directory
14. Type build.bat
15. Run test.exe

You can modify other options by editing the file tinyptc.h in the
\source\ directory. For the orginal readme for tinyptc, go to the
\source\ directory and look at the file readme.txt.

Instead of including the static libaries, it is more powerful to
add the source because you can modify specific options to suit
your needs.

Enjoy!

-dl

http://www.gaffer.org/tinyptc    -   tinyptc homepage
http://nasm.2y.net/              -   install nasm for windows
                                     to compile the mmx blitters
