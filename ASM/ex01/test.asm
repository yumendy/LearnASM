TITLE Ex01(ex01.asm)

; Description: My first asm program.
; Author: Duan Yi
; Revision date : 2014 - 9 - 25

INCLUDE Irvine32.inc

.data

var1 SBYTE -4, -2, 3, 1
var2 Word 1000h, 2000h, 3000h, 4000h
var3 sword -16, -42
var4 dword 1, 2, 3, 4, 5

.code
main PROC

mov eax, 0
mov al, var1


exit
main ENDP

END main
