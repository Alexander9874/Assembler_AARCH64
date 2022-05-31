CROSS_COMPILE ?= aarch64-linux-gnu-

PREFIX = /usr/local/arm64
LIBPATH = -L $(PREFIX)/lib/gcc/aarch64-linux-gnu/7.5.0 -L $(PREFIX)/aarch64-linux-gnu/libc/usr/lib
OBJPATH = $(PREFIX)/aarch64-linux-gnu/libc/usr/lib
LIBS = -lgcc -lgcc_eh -lc
PREOBJ = $(OBJPATH)/crt1.o $(OBJPATH)/crti.o
POSTOBJ = $(OBJPATH)/crtn.o

CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld

CCFLAGS = -g -c -O3
ASFLAGS = -g
LDFLAGS = -g -static

SRCS = prog18.c cipher.c ciphers.s ciphersimd.s
HEAD = prog18.h
OBJ = prog18.o
OBJC = cipher.o
OBJASM = ciphers.o
OBJSIMD = ciphersimd.o

EXE = prog18
EXEASM = prog18s
EXESIMD = prog18simd

all: $(SRCS) $(EXE) $(EXEASM) $(EXESIMD)

clean:
	rm -rf $(EXE) $(EXEASM) $(EXESIMD) $(OBJ) i $(OBJC) $(OBJASM) $(OBJSIMD)

$(OBJ): $(HEAD)
$(OBJC): $(HEAD)
$(OBJASM): $(HEAD)
$(OBJSIMD): $(HEAD)

$(EXE): $(OBJ) $(OBJC)
	$(LD) $(LDFLAGS) $(LIBPATH) $(PREOBJ) $(OBJ) $(OBJC) $(POSTOBJ) -\( $(LIBS) -\) -o $@

$(EXEASM): $(OBJ) $(OBJASM)
	$(LD) $(LDFLAGS) $(LIBPATH) $(PREOBJ) $(OBJ) $(OBJASM) $(POSTOBJ) -\( $(LIBS) -\) -o $@

$(EXESIMD): $(OBJ) $(OBJSIMD)
	$(LD) $(LDFLAGS) $(LIBPATH) $(PREOBJ) $(OBJ) $(OBJSIMD) $(POSTOBJ) -\( $(LIBS) -\) -o $@

.c.o:
	$(CC) $(CCFLAGS) $< -o $@

.s.o:
	$(AS) $(ASFLAGS) $< -o $@
