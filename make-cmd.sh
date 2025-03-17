mkdir build
$(brew --prefix aarch64-elf-gcc)/bin/aarch64-elf-gcc -DCONFIG_BOARD_PI3B -g -Wall -nostdlib -nostdinc -Iinclude -MMD -c src/kernel.c -o build/kernel_c.o
$(brew --prefix aarch64-elf-gcc)/bin/aarch64-elf-gcc -DCONFIG_BOARD_PI3B -g -Wall -nostdlib -nostdinc -Iinclude -MMD -c src/pl_uart.c -o build/pl_uart_c.o
$(brew --prefix aarch64-elf-gcc)/bin/aarch64-elf-gcc -g -Iinclude  -MMD -c src/boot.S -o build/boot_s.o
$(brew --prefix aarch64-elf-gcc)/bin/aarch64-elf-gcc -g -Iinclude  -MMD -c src/mm.S -o build/mm_s.o
$(brew --prefix aarch64-elf-binutils)/bin/aarch64-elf-ld -T src/linker.ld -o build/benos.elf  build/kernel_c.o build/pl_uart_c.o build/boot_s.o build/mm_s.o
$(brew --prefix aarch64-elf-binutils)/bin/aarch64-elf-objcopy build/benos.elf -O binary benos.bin


$(brew --prefix aarch64-elf-gdb)/bin/aarch64-elf-gdb --tui build/benos.elf

----
run:
qemu-system-aarch64 -machine raspi3b -nographic -kernel benos.bin

qemu-system-aarch64 -machine raspi3b  -nographic -kernel benos.bin -S -s

---

qemu-system-aarch64 -machine help

ps -elf | grep qemu | grep -v grep | awk '{print $2}' | xargs kill

----

qemu-system-aarch64 -machine raspi3b -serial null -serial mon:stdio  -nographic -kernel benos.bin -S -s