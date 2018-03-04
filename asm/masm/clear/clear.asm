; #########################################################################

    .186
    .model tiny

; #########################################################################

    .code

start:

    mov ax, 03h             ; set video mode 80x25, 16 colors
    int 10h                 ; change video mode & clear screen

    mov ax, 4c01h           ; set error code to 1
    int 21h                 ; return error code

end start

; #########################################################################
