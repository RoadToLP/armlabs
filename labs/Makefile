CC=gcc
LD=ld
all: lab1 lab2 lab3

lab1:
	$(CC) -g -c lab1.s
	$(LD) -g lab1.o ../lib/libasm.o -o lab1
lab2:
	$(CC) -g -c lab2.s
	$(LD) -g lab2.o ../lib/libasm.o -o lab2
lab3:
	$(CC) -g -c lab3.s
	$(LD) -g lab3.o ../lib/libasm.o -o lab3

clean:
	rm -f lab1 lab2 lab3
	rm -f lab1.o lab2.o lab3.o
