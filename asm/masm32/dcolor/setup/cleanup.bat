@ECHO OFF
:; shrink executable size
fs -rn:stub.com tmp.dat
upx --best tmp.dat
upxs tmp.dat
