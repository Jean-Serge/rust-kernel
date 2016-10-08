
TARGET=elf64
NASM=nasm -f $(TARGET)

default: run

all: multiboot_header boot linker iso

.PHONY: clean

multiboot_header: src/asm/multiboot_header.asm
	$(NASM) -o build/multiboot_header.o src/asm/multiboot_header.asm

boot: src/asm/boot.asm
	$(NASM) -o build/boot.o src/asm/boot.asm

linker: multiboot_header boot src/asm/linker.ld cargo
	ld --nmagic --output=build/kernel.bin --script=src/asm/linker.ld build/multiboot_header.o build/boot.o target/x86_64-unknown-rust_kernel-gnu/release/librust_kernel.a

iso: linker
	mkdir -p isofiles/boot/grub
	cp grub.cfg isofiles/boot/grub
	cp build/kernel.bin isofiles/boot
	grub-mkrescue -o build/os.iso isofiles

run: iso
	qemu-system-x86_64 -cdrom build/os.iso

cargo:
	xargo build --release --target x86_64-unknown-rust_kernel-gnu

clean:
	cargo clean
	rm build/*
