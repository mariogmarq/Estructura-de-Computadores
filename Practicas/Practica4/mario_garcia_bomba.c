// gcc -Og bomba.c -o bomba -no-pie -fno-guess-branch-probability

#include <stdio.h>     // para printf(), fgets(), scanf()
#include <stdlib.h>    // para exit()
#include <string.h>    // para strncmp()
#include <sys/time.h>  // para gettimeofday(), struct timeval

#define SIZE 100
#define TLIM 60

char password[] = "n\\g^cdk\\k\\\n";  // contraseÃ±a
int passcode = 314159;                // pin

void boom(void) {
  printf(
      "\n"
      "***************\n"
      "*** BOOM!!! ***\n"
      "***************\n"
      "\n");
  exit(-1);
}

void defused(void) {
  printf(
      "\n"
      "Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·\n"
      "Â·Â·Â· bomba desactivada Â·Â·Â·\n"
      "Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·Â·\n"
      "\n");
  exit(0);
}

void shift(char* pass, int shift) {
  for (int i = 0; i < SIZE; i++) {
    if (pass[i] == '\0' || pass[i] == '\n')
      break;
    else {
      pass[i] += shift;
    }
  }
}

int compare(char* word) {
  shift(word, -5);
  return strncmp(word, password, sizeof(password));
}

int main() {
  char pw[SIZE];
  int pc, n;

  struct timeval tv1, tv2;  // gettimeofday() secs-usecs
  gettimeofday(&tv1, NULL);

  do printf("\nIntroduce la contraseÃ±a: ");
  while (fgets(pw, SIZE, stdin) == NULL);

  if (compare(pw)) boom();
  gettimeofday(&tv2, NULL);
  if (tv2.tv_sec - tv1.tv_sec > TLIM) boom();

  do {
    printf("\nIntroduce el pin: ");
    if ((n = scanf("%i", &pc)) == 0) scanf("%*s") == 1;
  } while (n != 1);
  if (pc != passcode) boom();

  gettimeofday(&tv1, NULL);
  if (tv1.tv_sec - tv2.tv_sec > TLIM) boom();

  defused();
}
