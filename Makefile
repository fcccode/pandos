ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
c_src = $(wildcard ./src/*.c)
asm_src = $(wildcard ./src/*.asm)

c_src_bc = $(c_src:.c=.o)
asm_src_o = $(asm_src:.asm=.o)

CLANG = ./bin/llvm2_bin/clang
SYSROOT = --sysroot "$(ROOT_DIR)/sysroot"
CFLAGS = $(SYSROOT) -ffreestanding -nostdlib -g -O3 -emit-llvm -S --target=i686-pc-none-elf

LLC = ./bin/llvm2_bin/llc
LLCFLAGS = --x86-asm-syntax=intel -filetype=obj

ASM = nasm
ASMFLAGS = -felf32

LINKER = ld
LINKER_SCRIPT = $(ROOT_DIR)/src/link/linker.ld
LINKERFLAGS = -m elf_i386 -T $(LINKER_SCRIPT)

# Disable built-in rules
%.o: %.c

# Compile .c -> .ll 
%.ll: %.c
	$(CLANG) $(CFLAGS) $< -o $@

# Assemble .ll -> .o
%.o: %.ll
	$(LLC) $(LLCFLAGS) $< -o $@	

# NASM: Assemble .asm -> .o
%.o: %.asm
	$(ASM) $(ASMFLAGS) $< -o $@

# Full build
all: pandos.iso

run: all
	./qemu-run

# Compile all into objects
./build/pandos.bin: $(c_src_bc) $(asm_src_o)
	$(LINKER) $(LINKERFLAGS) $^ -o $@

# Create GRUB disk
pandos.iso: ./build/pandos.bin
	cp ./build/pandos.bin ./grub/isodir/boot/pandos.bin
	grub-mkrescue -o pandos.iso ./grub/isodir

# Clean up object files
clean:
	-rm $(c_src_bc) $(asm_src_o)
	-rm ./build/pandos.bin
	-rm pandos.iso
