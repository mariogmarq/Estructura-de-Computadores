.section .data
saludo:
    .ascii "Hello World\n"
longsaludo:
    .quad .-saludo  #la posicion actual menos la de saludo

.section .text
.global _start

_start:
    mov $1, %rax	#Solicitud de write
    mov $1, %rdi	#Stdout
    mov $saludo, %rsi   #Direccion
    mov longsaludo, %rdx #Datos
    syscall
    
    #Salida del programa
    mov $60, %rax
    mov $0, %rdi
    syscall
