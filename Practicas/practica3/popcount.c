#include <stdio.h>
#include <sys/time.h>

// Tests
#define WSIZE 8 * sizeof(int)
#if TEST == 1
#define SIZE 4
unsigned lista[] = {1, 1, 1, 1};
#define RESULT 4
#elif TEST == 2
#define SIZE 8
unsigned lista[] = {0x7fffffff, 0xffbfffff, 0xfffffdff, 0xfffffffe,
                    0x01000023, 0x00456700, 0x8900ab00, 0x00cd00ef};
#define RESULT 156
#elif TEST == 3
#define SIZE 8
unsigned lista[] = {0x0,        0x01020408, 0x35906a0c, 0x70b0d0e0,
                    0xffffffff, 0x12345678, 0x9abcdef0, 0xdeadbeef};
#define RESULT 116
#elif TEST == 4
#define NBITS 20
#define SIZE 1 << NBITS
unsigned lista[SIZE];
#define RESULT (NBITS * (1 << NBITS - 1))
#endif

void crono(int (*func)(), char* msg) {
  struct timeval tv1, tv2;
  long tv_usecs;

  gettimeofday(&tv1, NULL);
  int resultado = func(lista);
  gettimeofday(&tv2, NULL);

  tv_usecs = (tv2.tv_sec - tv1.tv_sec) * 1E6 + (tv2.tv_usec - tv1.tv_usec);
  printf("resultado = %d\t", resultado);
  printf("%s:\t%lo us  resultado = %d\n", msg, tv_usecs, RESULT);
}
int pcount_for(unsigned* l) {
  size_t i;
  size_t j;
  long x = 0;
  long result = 0;
  for (j = 0; j < SIZE; j++) {
    x = l[j];
    for (i = 0; i < WSIZE; i++) {
      result += x & 0x1;
      x >>= 1;
    }
  }
  return result;
}
int pcount_while(unsigned* x) {
  int valor = 0;
  long result = 0;
  unsigned long aux;
  while (valor < SIZE) {
    aux = x[valor];
    while (aux) {
      result += aux & 0x1;
      aux >>= 1;
    }
    ++valor;
  }
  return result;
}

int pcount_asm3(unsigned* lista) {
  long result = 0;
  long x;
  int i;
  for (i = 0; i < SIZE; i++) {
    x = lista[i];
    asm("\n"
        "ini3:        \n\t"
        "shr %[x]       \n\t"
        "adc $0, %[r]    \n\t"
        "test %[x],%[x]   \n\t"
        "jnz  ini3       \n\t"

        : [r] "+r"(result)
        : [x] "r"(x));
  }
  return result;
}

int pcount_asm4(unsigned* lista) {
  long result = 0;
  long x;
  int i;
  for (i = 0; i < SIZE; i++) {
    x = lista[i];
    asm("\n"
        "clc            \n\t"
        "ini4:        \n\t"
        "adc $0, %[r]   \n\t"
        "shr %[x]       \n\t"
        "jnz ini4       \n\t"
        "adc $0, %[r]   \n\t"

        : [r] "+r"(result)
        : [x] "r"(x));
  }
  return result;
}

int pcount_c5(unsigned* x) {
  long val = 0;
  size_t i;
  size_t j;
  int y;
  long resultado = 0;
  for (j = 0; j < SIZE; j++) {
    y = x[j];
    val = 0;
    for (i = 0; i < 8; i++) {
      val += y & 0x01010101;
      y >>= 1;
    }
    val += (val >> 32);
    val += (val >> 16);
    val += (val >> 8);
    resultado += val & 0xFF;
  }
  return resultado;
}

int pcount_naive6(unsigned* lista) {
  const unsigned long m1 = 0x5555555555555555;  // binary: 0101...
  const unsigned long m2 = 0x3333333333333333;  // binary: 00110011..
  const unsigned long m4 = 0x0f0f0f0f0f0f0f0f;  // binary: 4 zeros, 4 ones ...
  const unsigned long m8 = 0x00ff00ff00ff00ff;  // binary: 8 zeros, 8 ones ...
  const unsigned long m16 =
      0x0000ffff0000ffff;  // binary: 16 zeros, 16 ones ...

  size_t i;
  long result = 0;
  long x;
  for (i = 0; i < SIZE; i++) {
    x = lista[i];
    x = (x & m1) +
        ((x >> 1) & m1);  // put count of each 2 bits into those 2 bits
    x = (x & m2) +
        ((x >> 2) & m2);  // put count of each 4 bits into those 4 bits
    x = (x & m4) +
        ((x >> 4) & m4);  // put count of each 8 bits into those 8 bits
    x = (x & m8) +
        ((x >> 8) & m8);  // put count of each 16 bits into those 16 bits
    x = (x & m16) +
        ((x >> 16) & m16);  // put count of each 32 bits into those 32 bits
    result += x;
  }
  return result;
}

int pcount7(unsigned* lista) {
  const unsigned long m1 = 0x5555555555555555;  // binary: 0101...
  const unsigned long m2 = 0x3333333333333333;  // binary: 00110011..
  const unsigned long m4 = 0x0f0f0f0f0f0f0f0f;  // binary: 4 zeros, 4 ones ...
  const unsigned long m8 = 0x00ff00ff00ff00ff;  // binary: 8 zeros, 8 ones ...
  const unsigned long m16 =
      0x0000ffff0000ffff;  // binary: 16 zeros, 16 ones ...
  const unsigned long m32 = 0x00000000ffffffff;  // binary: 32 zeros, 32 ones

  size_t i;
  int result = 0;
  unsigned long y, x;
  if (SIZE & 0x3) printf("leyendo 128b pero len no múltiplo de 4\n");
  for (i = 0; i < SIZE; i += 4) {
    x = *(unsigned long*)&lista[i];
    y = *(unsigned long*)&lista[i + 2];

    x = (x & m1) + ((x >> 1) & m1);
    x = (x & m2) + ((x >> 2) & m2);
    x = (x & m4) + ((x >> 4) & m4);
    x = (x & m8) + ((x >> 8) & m8);
    x = (x & m16) + ((x >> 16) & m16);
    x = (x & m32) + ((x >> 32) & m32);

    y = (y & m1) + ((y >> 1) & m1);
    y = (y & m2) + ((y >> 2) & m2);
    y = (y & m4) + ((y >> 4) & m4);
    y = (y & m8) + ((y >> 8) & m8);
    y = (y & m16) + ((y >> 16) & m16);
    y = (y & m32) + ((y >> 32) & m32);

    result += x + y;
  }
  return result;
}

int pcount8(unsigned* array) {
  size_t i;
  int val, result = 0;
  int SSE_mask[] = {0x0f0f0f0f, 0x0f0f0f0f, 0x0f0f0f0f, 0x0f0f0f0f};
  int SSE_LUTb[] = {0x02010100, 0x03020201, 0x03020201, 0x04030302};
  // 3 2 1 0 7 6 5 4 1110 9 8 15141312
  if (SIZE & 0x3) printf("leyendo 128b pero len no múltiplo de 4\n");
  for (i = 0; i < SIZE; i += 4) {
    asm("movdqu %[x], %%xmm0\n\t"
        "movdqa %%xmm0, %%xmm1 \n\t"  // x: two copies xmm0-1
        "movdqu %[m], %%xmm6 \n\t"    // mask: xmm6
        "psrlw $4 , %%xmm1 \n\t"
        "pand %%xmm6, %%xmm0 \n\t"     //; xmm0 – lower nibbles
        "pand %%xmm6, %%xmm1 \n\t"     //; xmm1 – higher nibbles
        "movdqu %[l], %%xmm2 \n\t"     //; since instruction pshufb modifies LUT
        "movdqa %%xmm2, %%xmm3 \n\t"   //; we need 2 copies
        "pshufb %%xmm0, %%xmm2 \n\t"   //; xmm2 = vector of popcount lower
                                       // nibbles
        "pshufb %%xmm1, %%xmm3 \n\t"   //; xmm3 = vector of popcount upper
                                       // nibbles
        "paddb %%xmm2, %%xmm3 \n\t"    //; xmm3 – vector of popcount for bytes
        "pxor %%xmm0, %%xmm0 \n\t"     //; xmm0 = 0,0,0,0
        "psadbw %%xmm0, %%xmm3 \n\t"   //; xmm3 = [pcnt bytes0..7|pcnt
                                       // bytes8..15]
        "movhlps %%xmm3, %%xmm0 \n\t"  //; xmm0 = [ 0 |pcnt bytes0..7 ]
        "paddd %%xmm3, %%xmm0 \n\t"    //; xmm0 = [ not needed |pcnt bytes0..15]
        "movd %%xmm0, %[val] "
        : [val] "=r"(val)
        : [x] "m"(array[i]), [m] "m"(SSE_mask[0]), [l] "m"(SSE_LUTb[0]));
    result += val;
  }
  return result;
}

int pcount9(unsigned* array) {
  size_t i;
  unsigned x;
  int val, result = 0;
  for (i = 0; i < SIZE; i++) {
    x = array[i];
    asm("popcnt %[x], %[val]" : [val] "=r"(val) : [x] "r"(x));
    result += val;
  }
  return result;
}

int pcount10(unsigned* array) {
  size_t i;
  unsigned long x1, x2;
  long val;
  int result = 0;
  for (i = 0; i < SIZE; i += 4) {
    x1 = *(unsigned long*)&array[i];
    x2 = *(unsigned long*)&array[i + 2];
    asm("popcnt %[x1], %[val] \n\t"
        "popcnt %[x2],  %[x1] \n\t"
        "add %[x1], %[val]\n\t"
        : [val] "=&r"(val)
        : [x1] "r"(x1), [x2] "r"(x2));
    result += val;
  }
  return result;
}

int main() {
#if TEST == 0 || TEST == 4
  size_t i;  // inicializar array
  for (i = 0; i < SIZE; i++) lista[i] = i;
#endif
  crono(pcount_for, "popcount_for");
  crono(pcount_while, "popcount_while");
  crono(pcount_asm3, "popcount_asm3");
  crono(pcount_asm4, "popcount_asm4");
  crono(pcount_c5, "popcount_c5");
  crono(pcount_naive6, "popcount_naive");
  crono(pcount7, "popcount7");
  crono(pcount8, "popcount8");
  crono(pcount9, "popcount9");
  crono(pcount10, "popcount10");
}
