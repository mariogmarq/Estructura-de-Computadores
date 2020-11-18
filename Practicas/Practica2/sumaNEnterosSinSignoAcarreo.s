# programa que suma los elementos de una lista
# Se usan registros de 32 bits
#SECCION DE DATOS
.section .data
lista:	.int 0xffffffff, 1
longlista: .int (.-lista)/4	#Cada elemento ocupa 4 posiciones
resultado: .quad 0
formato: .ascii "suma = %lu = 0x%lx hex/n" #salida para printf

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
    jnc jump
    inc %edx
jump:
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

