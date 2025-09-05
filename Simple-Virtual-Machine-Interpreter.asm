INCLUDE Irvine32.inc

.data
heading BYTE "=== Simple Virtual Machine Interpreter ===",0
prompt BYTE "Enter a number: ",0
OP_PUSH BYTE 1
OP_ADD  BYTE 2
OP_SUB  BYTE 3
OP_MUL  BYTE 4
OP_DIV  BYTE 5
OP_PRINT BYTE 6
OP_HALT BYTE 7
OP_INPUT BYTE 8

bytecode BYTE OP_INPUT
         BYTE OP_PUSH,0,0,0,2
         BYTE OP_MUL
         BYTE OP_PRINT
         BYTE OP_HALT

stack DWORD 100 DUP(?)
sp DWORD 0

.code
main PROC
    mov edx,OFFSET heading
    call WriteString
    call CrLf

    mov esi, OFFSET bytecode
fetch:
    mov al,[esi]
    cmp al,OP_HALT
    je done
    cmp al,OP_PUSH
    je do_push
    cmp al,OP_ADD
    je do_add
    cmp al,OP_SUB
    je do_sub
    cmp al,OP_MUL
    je do_mul
    cmp al,OP_DIV
    je do_div
    cmp al,OP_PRINT
    je do_print
    cmp al,OP_INPUT
    je do_input
next:
    jmp fetch

do_push:
    add esi,1
    mov eax,[esi]
    add esi,4
    mov ecx,sp
    mov stack[ecx*4],eax
    inc sp
    jmp next

do_add:
    dec sp
    mov eax,stack[sp*4]
    dec sp
    add eax,stack[sp*4]
    mov stack[sp*4],eax
    inc sp
    add esi,1
    jmp next

do_sub:
    dec sp
    mov eax,stack[sp*4]
    dec sp
    sub stack[sp*4],eax
    inc sp
    add esi,1
    jmp next

do_mul:
    dec sp
    mov eax,stack[sp*4]
    dec sp
    imul eax,stack[sp*4]
    mov stack[sp*4],eax
    inc sp
    add esi,1
    jmp next

do_div:
    dec sp
    mov ebx,stack[sp*4]
    dec sp
    mov eax,stack[sp*4]
    cdq
    idiv ebx
    mov stack[sp*4],eax
    inc sp
    add esi,1
    jmp next

do_print:
    dec sp
    mov eax,stack[sp*4]
    call WriteInt
    call CrLf
    add esi,1
    jmp next

do_input:
    mov edx,OFFSET prompt
    call WriteString
    call ReadInt
    mov ecx,sp
    mov stack[ecx*4],eax
    inc sp
    add esi,1
    jmp next

done:
    exit
main ENDP
END main
