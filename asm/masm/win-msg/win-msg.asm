.model tiny
.code
org 100h

maine proc
	Mov	ah,01h
	mov	cx,2000h
	int	10h			; Set cursor off

	mov	ax,03h
	int	10h			; Clear screen

	mov	ah,9
	mov	dx, offset win_msgA
	int	21h			;Print Our Message

	xor	ah,ah
	int	16h			; Get key

	mov	ax,03h
	int	10h			; Clear screen

	mov	ah,01h
	mov	cx,0607h
	int	10h			; Set cursor on

	mov	ax, 4c00h
	int	21h			;Get out of here
maine endp

win_msgA db 'This program requires Microsoft Windows.',13,10,13,10,'Visit Nod Programming Inc. at:',13,10,'http://Come.To/NodProgrammingInc/',13,10,'$'
end maine