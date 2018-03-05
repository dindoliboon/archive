#!/usr/bin/tclsh

# //////////////////////////////////////////////////////////////////////////
#
# CSC-209, Program #1
#
# Read the following input from the keyboard: student name, four lab
# scores, four test scores, and a final exam score. Drop the lowest
# test score and obtain the final average along with the letter grade.
#
# Compiling:
#   % tclsh pgm1.tcl
#
# Functions:
#   CalculateAvg
#
# History (Legend: > Info, ! Fix, + New, - Removed):
#   1.0          9/21/2001   > Initial release.
#   1.1          9/30/2001   > Cleaned up code.
#
# Author:
#   DL (dl@tks.cjb.net / http://tks.cjb.net)
#
# //////////////////////////////////////////////////////////////////////////

# --------------------------------------------------------------------------
#
# Calculates the semester average.
#
# Arguments:
#   test   Sum of the highest 3 test scores.
#   final  Final exam score.
#   lab    Sum of the lab scores.
#
# Return Value:
#   Semester average.
#
# --------------------------------------------------------------------------
proc CalculateAvg {test final lab} {
  return [expr (.6 * ($test / 3)) + (.25 * $final) + (.15 * ($lab / 4))]
}

# **************************************************************************
# Obtain user name, lab scores, test scores, and final
# **************************************************************************
puts "Enter the Name of Student: "
set name [gets stdin]

puts "Enter the four lab scores: "
set tmp [gets stdin]
scan $tmp {%[0-9] %[0-9] %[0-9] %[0-9]} lab1 lab2 lab3 lab4

puts "Enter the four test scores: "
set tmp [gets stdin]
scan $tmp {%[0-9] %[0-9] %[0-9] %[0-9]} test1 test2 test3 test4

puts "Enter grade of Final: "
set final [gets stdin]  

# **************************************************************************
# Determine which test score is the lowest
# **************************************************************************
set lowscore $test1
if {$test2 < $lowscore} {set lowscore $test2}
if {$test3 < $lowscore} {set lowscore $test3}
if {$test4 < $lowscore} {set lowscore $test4}

# **************************************************************************
# Calculate semester average
# **************************************************************************
set answer [CalculateAvg \
  [expr $test1 + $test2 + $test3 + $test4 - $lowscore] $final \
  [expr $lab1 + $lab2 + $lab3 + $lab4]]

# **************************************************************************
# Determine letter grade based on semester average
# **************************************************************************
if {$answer >= 90} {set grade "A"} elseif {
    $answer >= 80} {set grade "B"} elseif {
    $answer >= 70} {set grade "C"} elseif {
    $answer >= 60} {set grade "D"} else   {
    set grade "F"
}

# **************************************************************************
# Display results
# **************************************************************************
puts "$name got an $grade for the semester.\n$name's average was $answer."
