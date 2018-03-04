; #########################################################################

    .186
    .model tiny
    .code

start:

; #########################################################################

    push cs               ; point data segment to code segment
    pop ds                ; since data is after code segment

    mov ax, 4c01h         ; return error code of 1
    int 21h               ; DOS interrupt

; #########################################################################

end start
