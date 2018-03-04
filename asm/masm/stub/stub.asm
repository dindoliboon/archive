; #########################################################################

    .186
    .model tiny

; #########################################################################

    .data
        message db 'Visit Nod Programming Inc. at:', 13, 10
                db 'http://come.to/NodProgrammingInc/', 13, 10, '$'

; #########################################################################

    .code

start:

    push cs                 ; point data segment to code segment
    pop ds                  ; release data segment

    mov ax, 03h             ; set video mode 80x25, 16 colors
    int 10h                 ; change video mode & clear screen

    mov dx, offset message  ; point to string
    mov ah, 9               ; print message
    int 21h

    mov ax, 4c01h           ; set error code to 1
    int 21h                 ; return error code

end start

; #########################################################################
