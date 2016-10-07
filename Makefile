
TARGET=elf64
NASM=nasm -f $(TARGET)

default: run

all: multiboot_header boot linker iso

.PHONY: clean

multiboot_header: multiboot_header.asm
	$(NASM) multiboot_header.asm

boot: boot.asm
	$(NASM) boot.asm

linker: multiboot_header boot linker.ld
	ld --nmagic --output=kernel.bin --script=linker.ld multiboot_header.o boot.o

iso: linker
	mkdir -p isofiles/boot/grub
	cp grub.cfg isofiles/boot/grub
	cp kernel.bin isofiles/boot
	grub-mkrescue -o os.iso isofiles

run: iso
	qemu-system-x86_64 -cdrom os.iso


clean:
	rm *.o *.bin *.iso
