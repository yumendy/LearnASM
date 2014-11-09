TITLE MASM BubbleSort						(main.asm)

; Description:
; 
; Revision date:

.686P		; Pentium Pro or later
.MODEL flat, stdcall
.STACK 4096
option casemap:none;  大小写不敏感

	
printf          PROTO C :ptr byte,:vararg
scanf           PROTO C :dword,:vararg
gets		PROTO C :ptr byte
getchar		PROTO C
ExitProcess	PROTO :DWORD	  	; exit program
psum		PROTO :DWORD

exit equ <INVOKE ExitProcess,0>

chr$ MACRO any_text:VARARG
        LOCAL txtname
        .data
          IFDEF __UNICODE__
            WSTR txtname,any_text
            align 4
            .code
            EXITM <OFFSET txtname>
          ENDIF

          txtname db any_text,0
          align 4
        .code
          EXITM <OFFSET txtname>
ENDM

INCLUDE Irvine32.inc
INCLUDELIB ..\USER32.LIB
INCLUDELIB ..\KERNEL32.LIB
INCLUDELIB ..\MSVCRT.LIB

.data

op1 qword 4 dup(0a2b2a40674981234h)
op2 qword 4 dup(08010870000234502h)
sum dword 4 dup(0FFFFFFFFh)

.code

Extended_Add proc
	pushad
	clc
L1:
	mov eax, [esi]
	sbb eax, [edi]
	pushfd
	mov [ebx], eax
	add esi, 4
	add edi, 4
	add ebx, 4
	popfd
	loop L1

	mov dword ptr [ebx], 0
	sbb dword ptr [ebx], 0
	popad
	ret
Extended_Add endp

main proc

	mov esi, offset op1
	mov edi, offset op2
	mov ebx, offset sum
	mov ecx, 8

	call Extended_Add

	mov eax, sum + 12
	call WriteHex
	mov eax, sum + 8
	call WriteHex
	mov eax, sum + 4
	call WriteHex
	mov eax, sum
	call WriteHex
	call Crlf
	exit
main	ENDP

  END main





