' ------------------------------------------------------------------------
'
' TinyPTC Example 1.0
' Ported from C to BCX
'
' mailto: dl @ tks.cjb.net
'    url: http://tks.cjb.net
'
' ------------------------------------------------------------------------

#include "tinyptc.h"
$library "tinyptc.lib"

$CCode
  #define LSHIFT(v, p) (v<<p)
  #define RSHIFT(v, p) (v>>p)
$CCode

' -------------------------------
' Declare constants and variables
' -------------------------------
Const WIDTH  = 320
Const HEIGHT = 200
Const SIZE   = WIDTH * HEIGHT

Dim noise
Dim carry
Dim index
Dim seed
Dim pixel[SIZE]

seed = 0x12345

' -----------------------------------
' Exit if unable to create PTC window
' -----------------------------------
If Not ptc_open("test", WIDTH, HEIGHT) Then
    Function = 1
End If

While (True)
    For index = 0 TO (SIZE - 1)
        noise = seed
        noise = RSHIFT(noise, 3)

        noise = noise Xor seed
        carry = noise And 1

        noise = RSHIFT(noise, 1)
        seed  = RSHIFT(seed, 1)

        seed  = seed Or LSHIFT(carry, 30)
        noise = noise And 0xFF

        pixel[index] = LSHIFT(noise, 16) Or LSHIFT(noise, 8) Or noise
    Next

    ptc_update(pixel)
Wend
