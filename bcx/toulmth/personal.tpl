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

<!-- these variables below are required      --!>
<!-- however you can rename them to anything --!>
<!-- you want... you can't rename the ones   --!>
<!-- on the right however.                   --!>
$ grpTitle	#gT
$ grpPosition	#gP
$ grpItems	#gI
$ plgName	#pN
$ plgVersion	#pV
$ lvwTTitle	#lT1
$ lvwTFileName	#lT2
$ lvwTSize	#lT3
$ lvwTDate	#lT4
$ lvwTRating	#lT5
$ lvwTDescrip	#lT6
$ lvwTAuthor	#lT7
$ lvwTContact	#lT8

<!-- these variables work in the loop code only --!>
$ lvwCTitle	#lC1
$ lvwCFileName	#lC2
$ lvwCSize	#lC3
$ lvwCDate	#lC4
$ lvwCRating	#lC5
$ lvwCDescrip	#lC6
$ lvwCAuthor	#lC7
$ lvwCContact	#lC8
$ curItem	#cI

<!-- new date/time: based on c format. this one has been designed   --!>
<!-- to have an extra parameter, which of course is the time.       --!>
<!-- as usual, you can not rename the variable on the right.        --!>
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --!>
<!--   $ variable name  ^  time/date code  ^  #  orginal variable   --!>
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --!>
<!-- Code	Replacement                                         --!>
<!-- %a	abbreviated weekday name, e.g., "Thu"                       --!>
<!-- %A	full weekday name, e.g., "Thursday"                         --!>
<!-- %b	abbreviated month name, e.g. "Jan"                          --!>
<!-- %B	full month name, e.g., "January"                            --!>
<!-- %c	local date and time representation                          --!>
<!-- %d	day of month, e.g., "01", "31"                              --!>
<!-- %H	hour (24 hour clock), e.g., "00", "23"                      --!>
<!-- %I	hour (12 hour clock), e.g., "01", "12"                      --!>
<!-- %j	day of the year, e.g., "001", "366"                         --!>
<!-- %m	month, e.g., "01", "12"                                     --!>
<!-- %M	minute, e.g., "00", "59"                                    --!>
<!-- %p	local equivalent of AM or PM                                --!>
<!-- %S	second, e.g., "00", "59"                                    --!>
<!-- %U	week number of the year (from 1st Sunday), e.g., "00", "53" --!>
<!-- %w	week day (Sunday is 0), e.g., "00", "06"                    --!>
<!-- %W	week number of the year (from 1st Monday), e.g., "00", "53" --!>
<!-- %x	local date representation                                   --!>
<!-- %X	local time representation                                   --!>
<!-- %y	year (no century), e.g., "00", "99"                         --!>
<!-- %Y	year (with century), e.g., "1995"                           --!>
<!-- %z	time zone name, if known                                    --!>
<!-- %%	a single %                                                  --!>
$ cur24Hour	^	%H:%M:%S	^	#cT24
$ cur12Hour	^	%I:%M:%S %p	^	#cT12
$ curDateLong	^	%B %d, %Y	^	#cDl
$ curDateShort	^	%m/%d/%y	^	#cDs

<!-- you can remove or add to these --!>
! translator	#BCX v1.87 BETA (12/30/2000)
! compiler	#LCC-Win32 1.3 Compiler (01/01/2001)
! linker	#LCC-Win32 1.3 Linker (01/01/2001)
! e-mail	#yourname@!server!
! sitename	#HTML-Out Database
! author	#your name
! server	#yourserver.com

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta http-equiv="Content-Language" content="en-us">
<title>Personal :: !sitename!</title>
</head>
<body>
<p>You are look at the "$grpTitle$" files!</p>
<table border="1" width="100%">


<!-- start of loop --!>
  <tr bgcolor=silver>
    <td colspan="4"><a href="http://www.!server!/$lvwCFileName$">$lvwCTitle$</a></td>
  </tr>
  <tr bgcolor=silver>
    <td colspan="4">$lvwCDescrip$</td>
  </tr>
  <tr bgcolor=silver>
    <td>Uploaded $lvwCDate$</td>
    <td>$lvwCRating$</td>
    <td>$lvwCSize$</td>
    <td>Coded by <a href="$lvwCContact$">$lvwCAuthor$</a></td>
  </tr>
<!-- end of loop --!>


</table>
<p>$grpItems$ files are available for download.<br>
Generated on $curDateLong$ on $cur12Hour$ by CDX v3.0 using $plgName$ v$plgVersion$.</p>
<p>Thanks for visiting !sitename!! Designed by <a href="mailto:!e-mail!">!author!</a>.</p>
</body>
</html>
