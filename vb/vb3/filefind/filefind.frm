��, !U  Z    Form1� KTFileFind Demo���     �  Q   B #����$Form15  6  7�  8Q  �0   Command2� Invalid Path callp8�w
 �5   Check1� Refresh each time��� ���  �2   Command1� Find matching files08_
w �"   Combo1��,*.EXE �   List1� �  �   Dir1�x ��
E �   Drive1�x x �
; �&   !Line13�0  H     H   �G    Label13� 
KTFileFind��� �  �Times New Roman  +Ba ���   Label12� uPositive number is number of found files.  Zero means no matching files.  negative number means an error has occured.��� x h'7 �   Label11�x  G�  �.   Label10� Num% result��� x G�  �&   Line12�h  �  �       �&   Line11�h  �  �      �&   Line10�h  �  h  �   �%   Line9��  �  `  �   �%   Line8�`    `  �   �%   Line7�@  �  `  �   �(   Label9� ,���     H�
� �  �*   Line6�  � �  P
  p  P
   �*   Line5��   �  P
     P
   �*   Label8� 1 )��� �   �
w�  �1   Label7� , filearray (),��� `�
G�  �.   Label6� *.EXE���   � ��
'�  �4   Label5� C:\windows\system\��� ��
_
�  �%   Line4�P
  P
     P
   �*   Line3��   @  �  �  P
   �*   Line2�  � �  �    P
   �*   Line1�    H  �  0  P
   �5   	Label3� Num% = KTFileFind (��� x �
� 	 �5   
Label4� filearray () result��� o	�  �5   Label2� File Specification:��� �'�  �"   Label1���� x ��  ��  �  __	 
�Q�Q,   � � � u ��`Z � �w� �   5���el 0tFW� � &��q              ,  z @Command1_Click��List1� C�@Command2_Click��path��DirName�  ATTR_DIRECTORY�  	ThenList1  @	Form_Load> 
Form_Click COM� check 
KTFindFile��filespecl filesS DirectoriesR�MaxItemG CurrentItem� Ended4�Pathsv�CurItem��a� form1e f� fddT Filers�
KTFileFind� One� Two3�CheckItO�Loop1��Loop2e swap��Temp? Text1   Text� ThatIt� ThatsIt� DirNmae� Fin] that% match�FileName�handler   X 
BunchFiles= Counts� Bunch7 list2� R� fresh� Skip� thenGoTo   &�Finished��Label1C Caption�@Drive1_Change��Dir1�Drive1k Drive��Combo1   ValueO@Dir1_Change� List� 	ListIndex� Combo1_Change  �Check1�@Combo1_Click��
FilesFound   MaxIten  @Check1_Click  �dummy` Errs& Dd VB] valid��PathFlag  	ReFreshIt�	ErrorFlag� Command3_Click� Command3��	FileCount��ReFreshPathJ no   more   this Label4m 	FileFoundsSkipPathBuilder  SkipFileSearch Errors� Srty@ShowCall   Shw   Label   Label3   tst Line1   Y2   X2   Line2� Line3   Line4   X1  �Label8� Label8_Click  �Label5  �Label6  �Num  �Label11   Label13_Click  �
MatchFiles   HandleIt  
DriveError  �TempPath  �	TempDrive      �     �	  ��������    Check1_Click0$      X  ?      #   7    9 	  ��������     Combo1_Click0$      X        #   7    9 	  ��������     Command1_Click0�     X  Z      $   7   � � �     � � �  >     �  �    ��   ��   v� ��  � � �� � I  ��� � I �  �� �� ��� 0 �  � 
 KTFileFind  & 2  �  �  Invalid Path! � 0 �  � 
 KTFileFind  & 8  8       l e    x    �� � I �  R��> ���  l e  R  �  x   RN ��  2 �  l e �  � No matching files found   x  8     9 	  ��������     Command2_Click0     X  z      $   7 �  "  C:\WINsdDOWS\  � �   �  H  C:\WINsdDOWS  � 
 f  *.exe    ��   ��   v�  �� � I & ��� � I �  ���� 0 �  � 
 KTFileFind  & 2 " �  �  Invalid Path! � 0 �  
 KTFileFind  & 8  8     9 	  ��������     Dir1_Change0$      X  �      #   7    9 	  ��������     Drive1_Change0�      X  �     O   � � ��     v   Set new path  � � � �  = �    ��   �  p  Drive not available!  �  �  �  KTFileFind Error  &   � � T       9 	  \ ������    	 Form_Load0�      X  �         �e � 
 &  *.EXE   x   �e � 
 V  *.TXT   x   �e � 
 �  *.BAT   x    #   7    9 	  ��������
    
 KTFileFind	��     v E   KTFileFind version 1.0 programmed by Karl Albrecht (KARL25@AOL.COM))  v =   NOTE - This function has added lines that display searchingA  v 1   information to Label1 (Label at bottom of Form)a  @ & v� �      �      & @   �       v   Rest vaiablesh  �  &  � � � �    v   Set up error handler O    v &  Add backslash to path if not present v /  Use GetAttr to cause an error if invalid pathv v ?  GetAttr doesn't like "\" on the end unless it's the root path   � �  �   � �� �  $ \ � I \  � O O  � �  J \ �  �  2 � v   See if drive only-  � �  �� I �  � O O 2 �  �  � �  �� � O O 8  8       v 7  If in auto and there is a previous path then check ito �� � � � � I �    >D v >  Check if new path is part of Paths() if so Skip path builder  � �  >�  � �  >� E �C  8      v   Dim Pathsn  � 2   >   v   Set Paths(1)  � �  >    v >   This label is to allow the Function to rebuild the directory  v =   Path if it finds that a new directory was created since they  v    Last Path refresht @	�  v /  Make a list of all sub directories under Path v   Reset vaiables � �G � w �    Building directory tree...   � �  �e    x    w0 d   v (  Find first directory in Paths() if any G  >�  K �   v *  If no directories don't look for anymore v 6  Can only happen on a Root directory with no sub dirs  � �  $    � E 4C   v (  Find additional directories in Paths() /   v /  Check if valid directory and filter out dots!u  � �  � . �  � �  � ..  � � I �  G  > � � O�  �  � 2   �  � 8   v "  If a valid directory then add it  ��  � I |  ��   G  > � � �  f \ �   > 8   v   Get next Directory  �   v #  If no more then exit this Do Loopt  � �  �    � E �; �  J h  v   Select next Path G�� G  v $  If at end of the list stop looking G� E \�w   J X   v   Sort directories  ��> ��"	  ��> ��	  �  > �  >� I 	   �  > �   �  > �  >   � �  > 8   �N ��   �N ��     v @   This label is to allow skipping of the Path builder to allow    v *   faster file searching if it's not needed �    v ;   If filespec = "" then don't find files.  This is to allowi  v &   refreshinf Paths() without searching   � �  
    � E .
C    v    Find files that match filespec � � � t  R�> ���  v 4  Make sure we are only checking paths that are subs v   of the called Path.l  R  > � �  �  � � I �  �t �  	 Checking   R  >�  � �  �e    x     R  > � � � K    v 6  ErrorFlag% is set when a path not found error occurs v 9  This is caused when a directory is deleted and Paths() a v 9  Is not refreshed.  If ErrorFlag%=1 then Path is skippeda ��� I �   �  J    � 1 � (��� � ( R  > � �  & (   J @ 8    8     RN ��   v 9  If Path was not in Paths() then it must have been addeda v 2  since the last refresh.  So..Go back and refresh t� � I @  C � 8    $  v #  Redim FilesFound to actual amount   �  &D � v �  �     � �    = h   ��    � V �   v   Subscript out of range �$&  �� � I D v !  Paths too small, make it bigger   � 2 �   >D R  2 � v &  FilesFound too samll, make it bigger  �� 2 �   &D R  8    v #  Incorrect path passed to functiong � 5 &  ��  v = h   v   Deleted Path still in Paths()t � L &  �� T    v   Unexpected error %  �� � �  v = h    :       9 	  z�������     ShowCall0�      X  7      v 8  Displays what will be called when KTFileFind is called   �  Z  "  � � � �  p  \ � �  ~  " �  � �  �  �  "  � �� �  �  " �  � �    �� �  �  ) �  � �    9 	  ��������   �