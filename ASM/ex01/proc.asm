TITLE Ex01(ex01.asm)

; Description: Asm program for proc.
; Author: Duan Yi
; Revision date : 2014-10-26

INCLUDE Irvine32.inc

.data

array BYTE 10h,20h,30h,40h,50h
the_sum dword 0

.code

sum PROC

mov eax, 0
L1:
	mov bl, [esi]
	movzx edx, bl
	add eax,edx
	add esi, 1
	LOOP L1

	ret

sum ENDP


main PROC

mov esi, offset array

mov ecx, lengthof array

call sum

mov the_sum, eax


exit
main ENDP

END main
