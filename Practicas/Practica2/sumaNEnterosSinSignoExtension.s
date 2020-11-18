# programa que suma los elementos de una lista
# Se usan registros de 32 bits
#SECCION DE DATOS
.section .data
#ifndef TEST
#define TEST 9 
#endif
    .macro linea
#if TEST==1
    .int 1,1,1,1
#elif TEST==2
    .int 0x0FFFFFFF, 0x0FFFFFFF,0x0FFFFFFF,0x0FFFFFFF
#elif TEST==3
    .int 0x10000000,0x10000000,0x10000000,0x10000000
#elif TEST==4
    .int 0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF
#elif TEST==5
    .int -1,-1,-1,-1
#elif TEST==6
    .int 200000000,200000000,200000000,200000000
#elif TEST==7
    .int 300000000,300000000,300000000,300000000
#elif TEST==8
    .int 5000000000,5000000000,5000000000,5000000000
#else
    .error "Definir test"
#endif
    .endm

lista:	.irpc i,1234
        linea
        .endr

longlista: .int (.-lista)/4	#Cada elemento ocupa 4 posiciones
resultado: .quad 0
formato: .ascii "resultado \t =   %18lu (uns)\n" 
.ascii "\t\t = 0x%18lx (hex)\n"
.asciz "\t\t = 0x %08x %08x\n"

# SECCION DE CODIGO
.section .text
main: .global main
    call trabajar
    call imprim_C
    call acabar
    ret

trabajar:
    mov $lista, %rbx # direccion de lista en rbx
    mov longlista, %ecx #numero de elementos de la lista
    call suma
    mov %eax, resultado #Se guarda el resultado para devolverlo
    mov %edx, resultado + 4
    ret

suma:
    mov $0, %eax
    mov $0, %edx
    mov $0, %rsi # Acarreo
bucle:		    # Pertenece a suma
    add (%rbx, %rsi, 4), %eax #eax += rbx + rdx * 4
    adc $0, %edx
    inc %rsi #incrementamos el contador
    cmp %rsi, %rcx
    jne bucle # jump en caso de que no coincidan rdx y rcx(longitud)
    ret

imprim_C:
    mov $formato, %rdi  #argumentos
    mov resultado, %rsi #argumentos
    mov resultado, %rdx #argumentos
    mov $0, %eax
    call printf
    ret

acabar:
    mov resultado, %edi
    call exit
    ret

