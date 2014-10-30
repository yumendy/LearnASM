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

INCLUDELIB ..\USER32.LIB
INCLUDELIB ..\KERNEL32.LIB
INCLUDELIB ..\MSVCRT.LIB

.data
 count	dword	0
 array  dword 100 DUP(?)
 flag byte 0
.code
main	PROC
;读入数组大小
	invoke	printf,chr$("Please input the count: ")
	invoke	scanf, chr$("%d"),offset count
	invoke	getchar
;读入数据
    mov ecx, count
    mov ebx, 1
    mov esi, offset array
L1: 
	push ecx
    invoke  printf,chr$("Please input No.%d: "), ebx
    invoke scanf, chr$("%d"), esi
    invoke  getchar
    inc ebx
    add esi, TYPE array
	pop ecx
    loop L1

    mov ecx, count
	dec ecx
L2:;
    push ecx
    mov esi, offset array
L3:
    mov eax, [esi]
    cmp [esi + TYPE array], eax
    jl L4
    xchg eax, [esi + TYPE array]
    mov [esi], eax
    mov flag, 1
L4:
    add esi, 4
    loop L3

L5:
    cmp flag, 0
    jz L6
    mov flag, 0
    pop ecx
    loop L2

L6:
	invoke	printf,chr$("The result is:",0dh,0ah)
  mov esi, offset array
  mov ecx, count
L7:
  mov eax, [esi]
  push ecx
  invoke printf,chr$("%d",0dh,0ah), eax
  pop ecx
  add esi, TYPE array
  loop L7
	invoke	getchar

	exit
main	ENDP

  END main
