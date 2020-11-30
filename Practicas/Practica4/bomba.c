// gcc -Og bomba.c -o bomba -no-pie

#include <stdio.h>	         // para printf(), fgets(), scanf()
#include <stdlib.h>	         // para exit()
#include <string.h>	         // para strncmp()
#include <sys/time.h>	     // para gettimeofday(), struct timeval

#define SIZE 100
#define TLIM 60

char password[]="dorado";			// contraseña
int  passcode = 161803;				// pin

void boom(void){
	printf(	"\n"
		"***************\n"
		"*** BOOM!!! ***\n"
		"***************\n"
		"\n");
	exit(-1);
}

void defused(void){
	printf(	"\n"
		"·························\n"
		"··· Bomba Desactivada ···\n"
		"·························\n"
		"\n");
	exit(0);
}

void cesar_1 (char *au) {
	for (int i=0; i<sizeof(au)-2; i++)
		au[i] = password[i] + 1;
	au[sizeof(au)-1] = '\0';
}

double aleacion (int au, int ag) {
	return au * 1.0 / ag;
}

int main() {
	char pw[SIZE], word[7];
	int  pc, n, plata = 241421;
	double electro, pc_;

	struct timeval tv1,tv2;	// gettimeofday() secs-usecs
	gettimeofday(&tv1,NULL);

	// Edición de parámetros: Password cifrado en César desplazado a la derecha en 1. Passcode dividido entre plata.
	cesar_1(word);
	electro = aleacion(passcode, plata);

// Sección Password

	do	printf("\nIntroduce la contraseña: ");
	while (	fgets(pw, SIZE, stdin) == NULL );

	for (int i=0; i<6; i++)
		pw[i] = pw[i] + 1;

	if (strncmp(pw,word,6) )
	    boom();

	gettimeofday(&tv2,NULL);
	if ( tv2.tv_sec - tv1.tv_sec > TLIM )
	    boom();

// Sección PIN

	do { 
		printf("\nIntroduce el pin: ");
		if ((n=scanf("%i",&pc))==0)
			scanf("%*s")==1;
	} while ( n!=1 ); 

	pc_ = aleacion(pc,plata);

	if ( pc_ != electro )
	    boom();

	gettimeofday(&tv1,NULL);
	if ( tv1.tv_sec - tv2.tv_sec > TLIM )
	    boom();

	defused();
} 
