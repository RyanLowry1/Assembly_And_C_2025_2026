; Name : Ryan Lowry
; File project2
section .data
    prompt1 db "Enter first number: ", 0      ; message asking for first number
    prompt2 db "Enter second number: ", 0     ; message asking for second number
    sumMsg db "The sum is: %d", 10, 0         ; message to show sum each loop
    resultMsg db "Final sum is: %d", 10, 0    ; message to show final total
    inputFormat db "%d", 0                    ; format for scanf to read integers

section .bss
    num1 resd 1       ; reserve space for first number 
    num2 resd 1       ; reserve space for second number
    sum  resd 1       ; total of all sums
    counter resd 1    ; loop counter runs 3 times
    temp resd 1       ; temporary storage for result of addition

section .text
    global main
    global REGISTER_ADDER
    extern printf, scanf   ; input and output functions

REGISTER_ADDER:
    mov eax, edi        ; move first number into eax
    add eax, esi        ; add second number to eax
    ret                 ; return result in eax

main:
    sub rsp, 8              ; fix stack alignment for function calls

    mov dword [sum], 0      ; set running total = 0
    mov dword [counter], 3  ; set loop to run 3 times

loop_start:

    mov rdi, prompt1        ; load prompt message
    xor rax, rax            ; clear rax before printf
    call printf             ; print message

    mov rdi, inputFormat    ; load format string %d into rdi
    mov rsi, num1           ; address to store input
    xor rax, rax            ; clear rax register
    call scanf              ; read first number

    mov rdi, prompt2        ; load second prompt
    xor rax, rax            ; clear rax register
    call printf             ; print message

    mov rdi, inputFormat    ; load format string %d into rdi
    mov rsi, num2           ; address to store second number
    xor rax, rax            ; clear rax register
    call scanf              ; read second number

    mov edi, [num1]         ; move first number into edi 
    mov esi, [num2]         ; move second number into esi
    call REGISTER_ADDER     ; call function

    mov [temp], eax         ; store result safely in memory

    ; print result of loop 
    mov esi, [temp]         ; move result into esi 
    mov rdi, sumMsg         ; print message
    xor rax, rax
    call printf             ; print result

    ; update total
    mov eax, [temp]         ; load result again
    add [sum], eax          ; add to total sum

    ; --- loop control ---
    dec dword [counter]     ; decrease loop counter dword = double
    jnz loop_start          ; repeat loop if not zero jnz = jump if not 0

    ; print final result
    mov eax, [sum]          ; load final sum
    mov esi, eax            ; move into esi for printf
    mov rdi, resultMsg      ; print message
    xor rax, rax
    call printf             ; print final result

    add rsp, 8              ; restore stack
    ret                     ; end program
