@echo off
ml.exe /c /coff aifo.asm
link.exe /SUBSYSTEM:CONSOLE aifo.obj
