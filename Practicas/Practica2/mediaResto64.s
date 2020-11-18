# programa que suma los elementos de una lista
# y calcula su media
# Se usan registros de 32 bits
#SECCION DE DATOS
.section .data
lista:	.int 1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2
longlista: .int (.-lista)/4	#Cada elemento ocupa 4 posiciones
resultado: .int 0
resto: .int 0
formato: .asciz "media = %d = 0x%x hex/nResto = %d = 0x%x hex/n" #salida para printf

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
    mov %eax, resultado #Se guarda el resultado de la media
    mov %edx, resto
    ret

suma:
    mov $0, %eax
    mov $0, %edx
    mov $0, %rsi # contador
    mov $0, %edi # acumulador
bucle:		    # Pertenece a suma
    mov (%rbx, %rsi, 4), %eax #eax += rbx + rdx * 4
    cltq     # extension de signo EAX->RAX
    add %rax, %rdi
    inc %rsi #incrementamos el contador
    cmp %rsi, %rcx
    jne bucle # jump en caso de que no coincidan rdx y rcx(longitud)
    
    mov %rdi, %rax
    cqto

    idiv %ecx
    
    ret

imprim_C:
    mov $formato, %rdi  #argumentos
    mov resultado, %rsi #argumentos
    mov resultado, %rdx #argumentos
    mov resto, %rcx
    mov resto, %r8
    mov $0, %eax
    call printf
    ret

acabar:
    mov resultado, %edi
    call exit
    ret

