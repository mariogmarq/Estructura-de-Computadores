# programa que suma los elementos de una lista
# Se usan registros de 32 bits
#SECCION DE DATOS
.section .data
lista:	.int 1,2,10,1,2,0b10,1,2,0x10
longlista: .int (.-lista)/4	#Cada elemento ocupa 4 posiciones
resultado: .int 0
formato: .asciz "suma = %u = 0x%x hex/n" #salida para printf

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
    ret

suma:
    push %rdx #Preservar rdx porque luego se cambia
    mov $0, %eax
    mov $0, %rdx
bucle:		    # Pertenece a suma
    add (%rbx, %rdx, 4), %eax #eax += rbx + rdx * 4
    inc %rdx #incrementamos el contador
    cmp %rdx, %rcx
    jne bucle # jump en caso de que no coincidan rdx y rcx(longitud)

    pop %rdx
    ret

imprim_C:
    mov $formato, %rdi  #argumentos
    mov resultado, %esi #argumentos
    mov resultado, %edx #argumentos
    mov $0, %eax
    call printf
    ret

acabar:
    mov resultado, %edi
    call exit
    ret

