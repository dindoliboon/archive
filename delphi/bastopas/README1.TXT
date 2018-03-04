		SHAREWARE !!
		
	Author:  Dietmar Reinwald
		Email: Dietmar.Reinwald@t-online.de
		CompuServe: 101761,335
-------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Whats new in Version 0.9:
-8)
a) Update of TArray.pas and BasFunc.pas
b) Translate Val --> StrToFloat, Str --> FloatToStr
c) In VB you can use Integer as Boolean. Be carefull with the translated code
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Whats new in Version 0.8:
-7)
a) Correct use of the classes T[Typ]Array and T[Typ]Matrix in the translated interface code
b) Correct translation of do .. Loop


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Whats new in Version 0.7:
-6)
a) Correct use of the classes T[Typ]Array and T[Typ]Matrix in the translated code if translating with option TArray
b) The class T[Typ]Matrix is in implemented in TArray.pas
c) The parameters in the methods Create, ReDim and ReDimPreserve of T[Typ]Matrix and T[Typ]Array are now the upper bound.
d) A new dialog to specify the translation of the types single and double.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Whats new in Version 0.6:
-5)
a) You can translate *.frm (only code). 
b) You can translate complete projects. Double-click on *.mak or *.vbp trys to load the complete projectfiles
     and read Global and Public arrays. Then errors like
	{Comment translator: Pointer not found in Sub/Function- or moduldeclaration. I think its as Sub/Function deklaration}
    (see under point 7) never will happen.
c) TArray.pas is in the place of THugeMem.pas. Its a better class of huge arrays, array greater than 64 KByte.
d) No limitation of the amount of translated subs/functions.
e) You can translate VB 3.0 foms (*.frm --> *.dfm ) with the shareware programm VB2Delph.exe of John C. Taylor (CompuServe, SWREG #8436) 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Whats new in Version 0.5:
-4)
a) Translation: CInt --> Trunc, CLng --> Trunc.
b) if Open file with Binary or Random than: Reset.
c) Types and variables are translated also if there are no sub or function in the modul.
d) You can translate *.cls files into Pascal/Delphi Units with class definition.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Whats new in Version 0.4:
-3)
a) Correct translation of types. 
b) Correct translation of const.
c) Correct class TVektorDouble in THugeMem.pas

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Whats new in Version 0.3:
-2)
a) Correct translation of types , for example in type: dim a%(n) --> a : array[n] of integer
b) Correct translation of static function/sub/variable

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Whats new in Version 0.2:
-1)
a) Correction: case n -> n:, case else -> case, and other little things.
b) New feature: the class THugeMem, very long arrays for the standart types.
   Now you can replace dynamic arrays in VB with the option "THugeMem". You
   get the source code when you push then button "Save ArrayPtr.pas, BasFunc.pas and THugeMem.pas".

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Whats new in Version 0.1:
0)
a)  If option 'Translate Sub' than additional translation of Sub DoEvents -> Application.ProcessMessages and Sub MsgBox(arg$)->ShowMessage(arg).
b) Function DoEvents in modul BasFunc.pas.
c) Corrected mistakes in function Right and function Left in modul BasFunc.pas.
d) Corrected mistake in translation of types: all types are now translated, in old version only the last type was.
e) If option 'Translate Sub' than you can choose the options 'len -> sizeOf' or 'len -> length'.
f) The first translates len into sizeOf, the second len into length. Choose the second if you deal with strings.
g) Corrected mistake: If you use compilerdirectives like #if, #else, #elseif, #const and #end if, translation is now good.
h) If the code-line is longer than 125 characters, the program tries to make a carriage return.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


1)
a) A later version additionally translates *.bas and *.cls into Java
b) A later version additionally translates *.bas and *.cls into C (C++)

2)
Assumption: 
a) The Visual Basic (VB) code is written with 'Option explicit' in the modul which you want to translate.
b) The VB code has to be syntactly correct
c) It doesnt translate Deftype statements
d) It doesnt creates Label for Goto Statements (in a later Version)
e) If option 'Translate Sub' than you can choose the Option 'len -> sizeOf' or 'len -> length'. (In a later Version: if variable is string then into 'length')
f) Arrays allocated with Dim and ReDim has the minimal lower bound zero. If you declared an array like Dim a#(n , 2 to m), I assume Dim a#(n,m).

3)
Designed for VB 3.0, but you can use it also for VB 4.0.
(It supports Private and Public)

4)
Translation from VB modul/class to pascal Unit.

5)
Dim and ReDim are quite difficult to translate (for example Dim a(n) or ReDim a(n) with n a variable).
I have solved the difficulties with allocate/deallocate of pointers.
For this case you need the file ArrayPtr.pas. You can create it with a button in BasToPas.exe. 
There are functions only for the simple types.
For other types you have to define the functions in a simliar way.
The allocation and deallocation assume that the lower bound is minimal zero.

6)
You can create pointers with the option 'With Info' or with 'No Info'.
a) Option 'With Info':
The informations about the size of the pointerarray are stored in the pointerarray.
Its the sure way to translate Dim, ReDim and Ubound.
b) Option 'No Info':
The informations about the size of the pointerarray are not stored.
If  (Re)Dim a(n), the translator stores n and use it later in Ubound(a) --> n and DisposeArray(a,n).
Be sure, that not in the meantime you make something like n = m with n <> m.
c) Option 'THugeMem':
Its Unit with several classes for the standart types. The arrays can have sizeOf(LongInt) elements.
It has methods ReDim and ReDimPreserve. The source you get when you push the
button "Save ArrayPtr.pas, BasFunc.pas and THugeMem.pas"

7)
If you do translate a modul which needs global variables (arrays) from
another modul, then copy the global variables into the modul
that you whant to translate. After you have done the translation,
remove this variables (pointers to arrays) from the implementation
part of the ouput file.
If you translate a project (*.mak, *.vbp) this is not necessary.
Example:

--------------------------------------------
---- Code of modul test --------------------

Option Explicit

Dim a$()

Function test% (a$(), m%)

 Dim b$()

 ReDim b$(m)
 ReDim a$(m)
 ReDim c$(m)

'Here is code

End Function

--------------------------------------------
------- Here the translated pascal code ----

Unit test1 ;

interface

function test (var a : stringArrayPtr ;var m : integer ) :  integer ;

implementation

const

	a : stringArrayPtr = nil ;


function test  (var a : stringArrayPtr ;var m : integer ) :  integer ;
 const
 	 b : stringArrayPtr = nil ;

 begin
 	b := nil ;

		 b := ReDimSTRINGVektor(b , m) ;

		 a := ReDimSTRINGVektor(a , m) ;

		 c := ReDimSTRINGVektor(c , m) ;
	{Comment translator: Pointer not found in Sub/Function- or moduldeclaration. I think its as Sub/Function deklaration}

{'Here is code}

 	b:= DisposeSTRINGArray(b) ;
 	c:= DisposeSTRINGArray(c) ;
 end ;

initialization
	a := nil ;
end.
--------------------------------------------

Thats the output. You see the comment

	{Comment translator: Pointer not found in Sub/Function- or moduldeclaration. I think its as Sub/Function deklaration}

The array c%() is not defined as Dim c%() at the top of function test. Its better 
you do it. When c%() is a Global variable from another modul, declare this at the
top of the modul test near Dim a%(). Then not happens

 	c:= DisposeINTEGERArray(c) ;

at the bottom of function test.
--------------------------------------------

8)
The translation of Dim and ReDim (Preserve) only with arrays
of one and two dimensions.

9)
No translation to boolean

10)
This pointerconcept works not when the type has length 1.
Then the pointers has maximal length 253.
To do it with strings is also a bad idea. 
There are better classes (TStringList) in Delphi  (in a later Version)

11)
Be sure that your VB code works with strings of length < 256.

12)
The best if  (Delphi 1.0):
	Type variant = string;

13)
For several special VB functions is the Unit BasTool.pas. You can create it with a button in BasToPas.exe.
You also then get the Unit Arrayptr.pas with all the pointer stuff.

14)
I translate Val to ValBasic, Str (Str$) to StrBasic. the functions are in modul BasFunc.pas.

15) Prepare code options
'Translate Sub':
If you unable this, no translation sqr->sqrt, a ^ b->exp(b*ln(a), log->ln, len->sizeof, Mid($)->copy, instr->pos or instr, val->ValBasic, Str($)->StrBasic, asc->ord,
String($)-> StringBasic, cdbl->double, cint->Trunc, clng->Trunc, csng->single, cstr->string, lcase($)->LowerCase, 
ucase($)->UpperCase, print->writeln, line input->readln, close->CloseFile, Kill->DeleteFile,name->RenameFile, get->seek, put->seek or write, 
Open [input,append,...]->AssignFile [Reset,Append,Rewrite],  Sub DoEvents -> Application.ProcessMessages, Sub MsgBox(arg$)->ShowMessage(arg)

16)
This program is a VB exe. You need a vbrun300.dll to run.

17)
This program is only a help tool for translation. Its up to you to control and correct the translated code.

_______________________________________________________________________________
No gaurantee for well translated code. I take no responsibility if you use the translated code. 
The use of the translated code is your risk and your responsibility.
You has to control the translated code and to test it very carefully and thouroughly.
The translation of Dim and ReDim is done with pointers, hence the translated code can be dangerous.
_______________________________________________________________________________

18)
This program is freeware.
If you find mistakes, please locate them and send the code to me.
If it is possible, you'll then receive a corrected version.

19)
If you have questions, comments and critics, then give me a mail.

Why this program:

BasToPas was created to help me converting mathematical VB code to pascal code because of two reasons.
a) I want include fast mathematical pascal code as *.dll in
my VB project.
b) I want to protect the code against recompilation.

