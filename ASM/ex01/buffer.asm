TITLE MASM Buffer						(main.asm)

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
_getche   PROTO C
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

buf byte 16 dup(?)
ip dword 0
op dword 0
n byte 0
_char byte 0

.code

;iq(&buf，&ip，chr)
iq PROC
  push ebp
  mov ebp, esp
  .if n == sizeof buf
      invoke  printf,chr$(0dh,0ah,"The querry is full!",0dh,0ah)
      mov eax, 0
      pop ebp
      ret
  .endif
  mov ebx, [ebp + 16];buf的地址
  mov ecx, [ebp + 12];ip的地址
  add ebx, [ecx];插入位置的地址
  mov al, [ebp + 8]
  mov [ebx], al
  inc n
  inc ip
  .if ip == 16
      mov ip, 0
  .endif
  mov eax, 1
  pop ebp
  ret

iq ENDP

;oq(&buf,&op,&chr)
oq PROC
  push ebp
  mov ebp, esp
  .if n == 0
      invoke printf,chr$(0dh,0ah,"The querry is empty!",0dh,0ah)
      mov eax, 0
      pop ebp
      ret
  .endif
  mov ebx,[ebp + 16];buf的地址
  mov ecx, [ebp + 12];ip的地址
  add ebx, [ecx];出队元素的地址
  mov al, [ebx]
  mov edx, [ebp + 8];char的地址
  mov [edx], al
  dec n
  inc op
  .if op == 16
      mov op, 0
  .endif
  mov eax, 1
  pop ebp
  ret

oq ENDP

main	PROC
L1:
  mov eax, 0
  invoke _getche
  .if al == 1bh
      jmp L0
  .elseif al >= 30h && al <= 39h
      jmp L2
  .elseif al >= 41h && al <= 5ah
      jmp L2
  .elseif al >= 61h && al <= 7ah
L2:
      push offset buf
      push offset ip
      push eax
      call iq
  .elseif al == '-'
      push offset buf
      push offset op
      push offset _char
      call oq
      invoke printf,chr$(0dh,0ah,"The element out querry is: %c",0dh,0ah), _char
  .endif

  mov ecx, 3
  loop L1
L0:
	exit
main	ENDP

  END main
