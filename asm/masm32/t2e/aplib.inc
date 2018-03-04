;
; aPLib compression library  -  the smaller the better :)
;
; MASM include file
;
; Copyright (c) 1998-2000 by Joergen Ibsen / Jibz
; All Rights Reserved
;

aP_pack            PROTO C, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
aP_workmem_size    PROTO C, :DWORD
aP_depack_asm      PROTO C, :DWORD, :DWORD
aP_depack_asm_fast PROTO C, :DWORD, :DWORD
