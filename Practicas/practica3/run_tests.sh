for i in $(seq 1 4); do
  rm media
  gcc -w -D TEST=$i -no-pie $1 -o media
  ./media
done
