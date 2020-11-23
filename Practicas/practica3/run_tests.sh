  echo "-O0"
for i in $(seq 1 10); do
  rm media
  gcc -O0 -w -D TEST=4 -no-pie $1 -o media
  ./media
done

  echo "-Og"
for i in $(seq 1 10); do
  rm media
  gcc -Og -w -D TEST=4 -no-pie $1 -o media
  ./media
done

  echo "-O1"
for i in $(seq 1 10); do
  rm media
  gcc -O1 -w -D TEST=4 -no-pie $1 -o media
  ./media
done

  echo "-O2"
for i in $(seq 1 10); do
  rm media
  gcc -O2 -w -D TEST=4 -no-pie $1 -o media
  ./media
done
