#CROSS_COMPILE ?= arm-none-linux-gnueabihf-
CROSS_COMPILE ?= arm-none-eabi-
#FILES = uart.s utils.s wdt.s cp15.s gpio.s rtc.s

#OBJS = startup.o uart.o wdt.o cp15.o rtc.o gpio.o prints.o delay.o ascii.o utils.o #string.o 

OBJDIR=obj/
SRCDIR=src/
OBJS = $(addprefix $(OBJDIR), startup.o uart.o wdt.o cp15.o rtc.o gpio.o prints.o delay.o ascii.o utils.o lab05.o interrupt.o)

$(OBJDIR)%.o: $(SRCDIR)%.s
	mkdir -p $(OBJDIR)
	$(CROSS_COMPILE)as $< -o $@

all: $(OBJS)
	$(CROSS_COMPILE)ld -o $(OBJDIR)startup -T $(SRCDIR)memmap $(OBJS)
	$(CROSS_COMPILE)objcopy $(OBJDIR)startup $(OBJDIR)startup.bin -O binary
	$(CROSS_COMPILE)objdump -DSx -b binary -marm $(OBJDIR)startup.bin > $(OBJDIR)startup.lst
	cp $(OBJDIR)*.bin /tftpboot

clean:
	rm -rf $(OBJDIR) *.bin *.lst

# all:  $(OBJS)
# 	$(CROSS_COMPILE)ld -o startup -T memmap $(OBJS)
# 	$(CROSS_COMPILE)objcopy startup startup.bin -O binary
# 	$(CROSS_COMPILE)objdump -DSx -b binary -marm startup.bin > startup.lst
# 	cp *.bin /tftpboot

# clean:
# 	rm *.o *.bin *.lst
	

