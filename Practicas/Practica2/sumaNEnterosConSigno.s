# programa que suma los elementos de una lista
# Se usan registros de 32 bits
#SECCION DE DATOS
.section .data
#ifndef TEST
#define TEST 9 
#endif
    .macro linea
#if TEST==1
    .int -1,-1,-1,-1
#elif TEST==2
    .int 0x04000000,0x04000000,0x04000000,0x04000000
#elif TEST==3
    .int 0x08000000,0x08000000,0x08000000,0x08000000
#elif TEST==4
    .int 0x10000000,0x10000000,0x10000000,0x10000000
#elif TEST==5
    .int -0x7fffffff,-0x7fffffff,-0x7fffffff,-0x7fffffff
#elif TEST==6
    .int 0x80000000,0x80000000,0x80000000,0x80000000
#elif TEST==7
    .int 0xf0000000,0xf0000000,0xf0000000,0xf0000000
#elif TEST==8
    .int 0xf8000000,0xf8000000,0xf8000000,0xf8000000
#elif TEST==9
    .int 0xf7ffffff,0xf7ffffff,0xf7ffffff,0xf7ffffff
#elif TEST==10
    .int 100000000,100000000,100000000,100000000
#elif TEST==11
    .int 200000000,200000000,200000000,200000000
#elif TEST==12
    .int 300000000,300000000,300000000,300000000
#elif TEST==13
    .int 2000000000,2000000000,2000000000,2000000000
#elif TEST==14
    .int 3000000000,3000000000,3000000000,3000000000
#elif TEST==15
    .int -100000000,-100000000,-100000000,-100000000
#elif TEST==16
    .int -200000000,-200000000,-200000000,-200000000
#elif TEST==17
    .int -300000000,-300000000,-300000000,-300000000
#elif TEST==18
    .int -2000000000,-2000000000,-2000000000,-2000000000
#elif TEST==19
    .int -3000000000,-3000000000,-3000000000,-3000000000
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
    mov $0, %rsi # contador
    mov $0, %ebp # acumuladores
    mov $0, %edi # acumuladores
bucle:		    # Pertenece a suma
    mov (%rbx, %rsi, 4), %eax #eax += rbx + rdx * 4
    cltd     # extension de signo edx:eax
    add %eax, %ebp
    adc %edx, %edi
    inc %rsi #incrementamos el contador
    cmp %rsi, %rcx
    jne bucle # jump en caso de que no coincidan rdx y rcx(longitud)
    
    mov %ebp, %eax
    mov %edi, %edx

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

