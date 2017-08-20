## Debug notes
##   1. Using VAR for multiple OBJ/FILES seem to not reliable.
##   2. Found CC_FILE vs. OBJ mismatch.
##   3. Using pattern (%) is better but can't selectively choose.
##   4. For socket, can't compile with "c99". Only "gnu99".

# Compiler to use
CC=gcc
INCPATH=/home/marcel/Proj/lib/cpp/src/mysocket
LIBPATH=/home/marcel/Proj/lib/cpp/obj
CC_FLAGS=-std=c99 -iquote $(INCPATH) -Wa,-adhln -g

test.o: test.c
	@echo '------------EXECUTABLES-------------'
	$(CC) $(CC_FLAGS) -L$(LIBPATH) test.c -o test.o -lmylib -lmysocket -pthread > test.s
	@echo '------------------------------------'

all: test.o

.PHONY: clean
clean:
	-rm test.o $(OBJ) $(SO_OBJ)
	-rm *.s
