del /q feed.exe main.o
gcc -c main.c
gcc -Wl -o feed.exe main.o c.dll -lws2_32
