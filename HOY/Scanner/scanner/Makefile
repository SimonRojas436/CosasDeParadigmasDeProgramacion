CC = gcc
all: mmc
mmc: main.c scanner.h scanner.o
	$(CC) -c main.c
	$(CC) -o mmc main.o scanner.o

test: clean mmc
	cmd /c "mmc < test.ok.micro"
	cmd /c "mmc < test.error-lex.micro"

clean:
	del /Q *.o
	del /Q mmc.exe
