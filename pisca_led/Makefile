CROSS_COMPILE ?= arm-none-linux-gnueabihf-

all: led_USR0.s
	$(CROSS_COMPILE)as led_USR0.s -o led_USR0.o
	$(CROSS_COMPILE)objcopy led_USR0.o led_USR0.bin -O binary
	$(CROSS_COMPILE)objdump -D -b binary -marm led_USR0.bin > led_USR0.lst
	cp *.bin /tftpboot


clean:
	rm *.o *.bin *.lst
