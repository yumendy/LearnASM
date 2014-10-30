TITLE Ex01				(ex01.asm)

; Description: My first asm program.
; Author: Duan Yi
; Revision date: 2014-9-25

INCLUDE Irvine32.inc

.data

vara BYTE -2
varb SBYTE -2

.code
main PROC
	
	mov al,vara
	mov bl,varb

	
    exit
main ENDP

END main
