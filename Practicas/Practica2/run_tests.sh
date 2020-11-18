for i in $(seq 1 8); do
  rm media
  gcc -w -x assembler-with-cpp -D TEST=$i -no-pie $1 -o media
  printf "__TEST%02d__%35s\n" $i "" | tr " " "-" ; ./media
done
