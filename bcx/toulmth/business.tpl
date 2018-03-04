<!-- limitations/errors due to me being lazy --!>
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --!>
<!--           cannot use orginal right vars --!>
<!--         cannot change case of date/time --!>
<!--         left-vars can not contain # sym --!>
<!--       vars are *not* multi-line capable --!>
<!--    time-vars can not contain ^ or # sym --!>
<!-- possible length limit on custom strings --!>
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --!>
<!-- this is an in-house program, so no help --!>
<!-- will be available. your only help are   --!>
<!-- these crappy comments in the .dat file. --!>
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --!>
<!--                                01.01.01 --!>

<!-- this is my 'business' template that shows --!>
<!-- how to use the alternating even/odd printing --!>
$ Group Title	#gT
$ Group Position#gP
$ Group Items	#gI
$ Plugin Name	#pN
$ Plugin Version#pV
$ hTitle	#lT1
$ hFileName	#lT2
$ hSize		#lT3
$ hDate		#lT4
$ hRating	#lT5
$ hDescription	#lT6
$ hAuthor	#lT7
$ hContact	#lT8

$ Title		#lC1
$ FileName	#lC2
$ Size		#lC3
$ Date		#lC4
$ Rating	#lC5
$ Description	#lC6
$ Author	#lC7
$ Contact	#lC8
$ Current Item	#cI

$ Hour 24	^	%H:%M:%S	^	#cT24
$ Hour 12	^	%I:%M:%S %p	^	#cT12
$ Date Long	^	%B %d, %Y	^	#cDl
$ Date Short	^	%m/%d/%y	^	#cDs

$ File 1	^	test.txt	^	#f1
$ File 2	^	test.txt	^	#f2
$ File 3	^	test.txt	^	#f3
$ File 4	^	test.txt	^	#f4
$ File 5	^	test.txt	^	#f5

! Server 1	#http://members.xoom.com/server/files/asm/
! Server 2	#http://free.prohosting.com/~server/files/asm/
! Server 3	#http://server.webjump.com/files/asm/
! Site Name	#Super Site

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="content-type" content="text/html;charset=iso-8859-1">
<META http-equiv="pics-label" content='(PICS-1.1 "http://www.classify.org/safesurf/" l r (SS~~000 1))'>
<META name="keywords" content="files,download">
<META name="description" content="Contains lots of good files to download!">
<TITLE>!Site Name! :: $Group Title$</TITLE>
</HEAD>
<BODY bgcolor="#FFFFFF" text="#000000" link="#003399" alink="#808080" vlink="#003399">
<FONT face="Verdana" size=2>
<B>$Group Title$</B> Files ...<BR>
<!-- start of loop even --!>
<FONT color="gray">$Title$</FONT> ($Size$) - $Description$<BR>
Download from <A href="!Server 1!$FileName$">Xoom</A> or <A href="!Server 2!$FileName$">Prohosting</A> or <A href="!Server 3!$FileName$">Web Jump</A><BR>
<BR>
<!-- end of loop even --!>
<!-- start of loop odd --!>
<FONT color="blue">$Title$</FONT> ($Size$) - $Description$<BR>
Download from <A href="!Server 1!$FileName$">Xoom</A> or <A href="!Server 2!$FileName$">Prohosting</A> or <A href="!Server 3!$FileName$">Web Jump</A><BR>
<BR>
<!-- end of loop odd --!>
Generated with $Plugin Name$ version $Plugin Version$ on $Date Long$ at $Hour 12$.<BR>
There are $Group Items$ available for download.
</FONT>
</BODY>
</HTML>
