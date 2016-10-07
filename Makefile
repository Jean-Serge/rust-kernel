
NASM=nasm

all: multiboot_header boot


multiboot_header: multiboot_header.asm
	$(NASM) -f elf64 multiboot_header.asm

boot: boot.asm
	$(NASM) -f elf64 boot.asm

linker: multiboot_header boot linker.ld
	ld --nmagic --output=kernel.bin --script=linker.ld multiboot_header.o boot.o
