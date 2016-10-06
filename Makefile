
NASM=nasm

all: multiboot_header boot


multiboot_header: multiboot_header.asm
	$(NASM) -f elf64 multiboot_header.asm


boot: boot.asm
	$(NASM) -f elf64 boot.asm
