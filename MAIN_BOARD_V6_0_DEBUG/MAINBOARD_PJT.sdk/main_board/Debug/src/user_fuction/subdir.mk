################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/user_fuction/axi_gpio_control.c \
../src/user_fuction/interrupt.c \
../src/user_fuction/monitor.c \
../src/user_fuction/motor.c \
../src/user_fuction/user_uart.c 

OBJS += \
./src/user_fuction/axi_gpio_control.o \
./src/user_fuction/interrupt.o \
./src/user_fuction/monitor.o \
./src/user_fuction/motor.o \
./src/user_fuction/user_uart.o 

C_DEPS += \
./src/user_fuction/axi_gpio_control.d \
./src/user_fuction/interrupt.d \
./src/user_fuction/monitor.d \
./src/user_fuction/motor.d \
./src/user_fuction/user_uart.d 


# Each subdirectory must supply rules for building sources it contributes
src/user_fuction/%.o: ../src/user_fuction/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -I../../main_board_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


