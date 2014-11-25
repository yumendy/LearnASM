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

num1 sbyte 1
num2 sbyte -1
num3 sbyte 0

.code


main proc
	neg num1
	neg num2
	neg num3
	
	exit
main	ENDP

  END main





