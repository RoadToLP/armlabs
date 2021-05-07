CC = gcc
LD = ld
all:
	make -C ./lib
	make -C ./labs
clean:
	make -C ./lib clean
	make -C ./labs clean

