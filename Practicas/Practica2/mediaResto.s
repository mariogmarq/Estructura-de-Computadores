# programa que suma los elementos de una lista
# y calcula su media
# Se usan registros de 32 bits
#SECCION DE DATOS
.section .data
#ifndef TEST
#define TEST 20 
#endif
    .macro linea
#if TEST==1
    .int 1,2,1,2
#elif TEST==2
    .int -1,-2,-1,-2
#elif TEST==3
    .int 0x7fffffff,0x7fffffff,0x7fffffff,0x7fffffff
#elif TEST==4
    .int 0x80000000,0x80000000,0x80000000,0x80000000
#elif TEST==5
    .int 0xffffffff,0xffffffff,0xffffffff,0xffffffff
#elif TEST==6
    .int 2000000000,2000000000,2000000000,2000000000
#elif TEST==7
    .int 3000000000,3000000000,3000000000,3000000000
#elif TEST==8
    .int -2000000000,-2000000000,-2000000000,-2000000000
#elif TEST==9
    .int -3000000000,-3000000000,-3000000000,-3000000000
#elif TEST>=10 && TEST <=14
    .int 1,1,1,1
#elif TEST >= 15 && TEST<=19
    .int -1,-1,-1,-1
#else
    .error "Definir test"
#endif
    .endm

    .macro linea0
#if TEST>=1 && TEST<=9
    linea
#elif TEST==10
    .int 0,2,1,1
#elif TEST==11
    .int 1,2,1,1
#elif TEST==12
    .int 8,2,1,1
#elif TEST==13
    .int 15,2,1,1
#elif TEST==14
    .int 16,2,1,1
#elif TEST==15
    .int 0,-2,-1,-1
#elif TEST==16
    .int -1,-2,-1,-1
#elif TEST==17
    .int -8,-2,-1,-1
#elif TEST==18
    .int -15,-2,-1,-1
#elif TEST==19
    .int -16,-2,-1,-1
#else
    .error "Definir test"
#endif
    .endm



lista:	    linea0 
        .irpc i,123
            linea
        .endr

longlista: .int (.-lista)/4	#Cada elemento ocupa 4 posiciones
media: .int 0
resto: .int 0
formato: .asciz "Media = %d = 0x%x hex\n Resto = %d = 0x%x hex\n"

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
    mov %eax, media #Se guarda el resultado de la media
    mov %edx, resto
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

    idiv %ecx
    
    ret

imprim_C:
    mov $formato, %rdi  #argumentos
    mov media, %esi #argumentos
    mov media, %edx #argumentos
    mov resto, %ecx
    mov resto, %r8
    mov $0, %eax
    call printf
    ret

acabar:
    mov media, %edi
    call exit
    ret

