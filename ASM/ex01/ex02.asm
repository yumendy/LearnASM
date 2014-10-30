TITLE Ex02(ex02.asm)

; Description: My first asm program.
; Author: Duan Yi
; Revision date : 2014 - 10 - 11

INCLUDE Irvine32.inc

.data

List WORD 1000h, 2000h, 3000h, 3500h
ListSize WORD ($ - List) / TYPE WORD 

.code
main PROC

	movzx ECX, ListSize
	mov EAX, 0
	mov EDI, OFFSET List
L1:
	add EAX, [EDI]
	add EDI, TYPE List
	LOOP L1

	exit
main ENDP

END main
