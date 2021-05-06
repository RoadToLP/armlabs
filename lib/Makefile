CC = gcc
LD = ld
SOURCES = $(wildcard *.s)
OBJS = ${SOURCES:.s=.o}
all: $(OBJS)
	$(LD) -g -r $(OBJS) -o libasm.o
$(OBJS):
	$(CC) -g -c $(patsubst %.o,%.s,$@)
clean:
	rm -f $(OBJS)
	rm -f libasm.o
