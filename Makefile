# Makefile for STM32F10x

# User Definitions

project_name = STM32F10x_project
device_vol = md
compiler_root = /home/johnson/Downloads/gcc-arm-none-eabi-8-2019-q3-update
StdPeriph_root = /home/johnson/Downloads/STM32F10x_StdPeriph_Lib_V3.5.0

USER_INCLUDE = export C_INCLUDE_PATH=./src:./src/*/:./src/*/*/

# Automatic Defintitions
target = $(project_name)

device_vol_upper = $(shell echo $(device_vol) | tr a-z A-Z)

USERCODE_SRC := $(wildcard ./src/*.c ./src/*/*.c ./src/*/*/*.c)
USERCODE_OBJ := $(addprefix ./obj/, $(notdir $(USERCODE_SRC:%.c=%.o)))

STDPERIPH_SRC := $(wildcard $(StdPeriph_root)/Libraries/STM32F10x_StdPeriph_Driver/src/*.c)
STDPERIPH_OBJ := $(addprefix ./obj/, $(notdir $(STDPERIPH_SRC:%.c=%.o)))

CMSIS_SRC = $(StdPeriph_root)/Libraries/CMSIS/CM3/CoreSupport/core_cm3.c
CMSIS_OBJ = ./obj/core_cm3.o

SYSTEM_SRC = $(StdPeriph_root)/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/system_stm32f10x.c
SYSTEM_OBJ = ./obj/system_stm32f10x.o

STARTUP_SRC = $(StdPeriph_root)/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/startup/TrueSTUDIO/startup_stm32f10x_$(device_vol).s
STARTUP_OBJ = ./obj/startup_stm32f10x_$(device_vol).o

FLASH_SRC = ./lib/devices/$(device_vol)/stm32_flash.ld

# Binarary files
ELF_FILE = ./bin/$(project_name).elf
BIN_FILE = ./bin/$(project_name).bin
HEX_FILE = ./bin/$(project_name).hex

########## Compile Configurations ##########
ARMCC = $(compiler_root)/bin/arm-none-eabi-gcc
ARMCC_INCLUDE_DIRS = \
	-I $(StdPeriph_root)/Libraries/CMSIS/CM3/CoreSupport\
	-I $(StdPeriph_root)/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x\
	-I $(StdPeriph_root)/Libraries/STM32F10x_StdPeriph_Driver/inc\
	-I ./lib/devices/*/\
	-I ./src\
	-I ./src/*/\
	-I ./src/*/*/
ARMCC_FLAGS = -mthumb -mcpu=cortex-m3

########## Scripts ##########
.PHONY: all elf bin hex clean

all: $(BIN_FILE) $(HEX_FILE)
	@echo "Successfully built all"

$(BIN_FILE): $(ELF_FILE)
	@echo "Operation not supported"
	-mkdir ./bin
	$(compiler_root)/bin/arm-none-eabi-objcopy $(ELF_FILE) $(BIN_FILE)
	@echo "Successfully built $(target).bin"

$(HEX_FILE): $(ELF_FILE)
	@echo "Building $(target).hex"
	$(compiler_root)/bin/arm-none-eabi-objcopy $(ELF_FILE) -O ihex $(HEX_FILE)
	@echo "Successfully built $(target).hex"

$(ELF_FILE): \
	$(USERCODE_OBJ) \
	$(STDPERIPH_OBJ) \
	$(CMSIS_OBJ) \
	$(SYSTEM_OBJ) \
	$(STARTUP_OBJ)
	
	@echo "Linking files"
	-mkdir ./bin
	$(ARMCC) $(ARMCC_FLAGS) -specs=nosys.specs -static -Wl,-cref,-u,Reset_Handler -Wl,-Map=test.map -Wl,--gc-sections -Wl,--defsym=malloc_getpagesize_P=0x80 -Wl,--start-group -lc -lm -Wl,--end-group -T $(FLASH_SRC) $(wildcard ./obj/*.o) -o $(ELF_FILE)
	@echo "Successfully linked files to $(target).elf"

obj/%.o: ./src/%.c
	@echo "Building usercode"
	-mkdir ./obj
	$(USER_INCLUDE)
	$(ARMCC) -c $(ARMCC_FLAGS) $(ARMCC_INCLUDE_DIRS) -D STM32F10X_$(device_vol_upper) -D USE_STDPERIPH_DRIVER -o $@ $<
obj/%.o: ./src/*/%.c
	@echo "Building usercode"
	-mkdir ./obj
	$(USER_INCLUDE)
	$(ARMCC) -c $(ARMCC_FLAGS) $(ARMCC_INCLUDE_DIRS) -D STM32F10X_$(device_vol_upper) -D USE_STDPERIPH_DRIVER -o $@ $<
obj/%.o: ./src/*/*/%.c
	@echo "Building usercode"
	-mkdir ./obj
	$(USER_INCLUDE)
	$(ARMCC) -c $(ARMCC_FLAGS) $(ARMCC_INCLUDE_DIRS) -D STM32F10X_$(device_vol_upper) -D USE_STDPERIPH_DRIVER -o $@ $<

obj/%.o: $(StdPeriph_root)/Libraries/STM32F10x_StdPeriph_Driver/src/%.c
	@echo "Building StdPeriph"
	-mkdir ./obj
	$(USER_INCLUDE)
	$(ARMCC) -c $(ARMCC_FLAGS) $(ARMCC_INCLUDE_DIRS) -D STM32F10X_$(device_vol_upper) -D USE_STDPERIPH_DRIVER -o $@ $<
	@echo "Successfully built StdPeriph"

$(CMSIS_OBJ): $(CMSIS_SRC)
	@echo "Building CMSIS"
	-mkdir ./obj
	$(ARMCC) -c $(ARMCC_FLAGS) -o $(CMSIS_OBJ) $(CMSIS_SRC)
	@echo "Successfully built CMSIS"

$(SYSTEM_OBJ): $(SYSTEM_SRC)
	@echo "Building system"
	-mkdir ./obj
	$(USER_INCLUDE)
	$(ARMCC) -c $(ARMCC_FLAGS) $(ARMCC_INCLUDE_DIRS) -D STM32F10X_$(device_vol_upper) -D USE_STDPERIPH_DRIVER -o $(SYSTEM_OBJ) $(SYSTEM_SRC)
	@echo "Successfully built system"

$(STARTUP_OBJ): $(STARTUP_SRC)
	@echo "Building startup"
	-mkdir ./obj
	$(ARMCC) -c $(ARMCC_FLAGS) -g -Wa,--warn -o $(STARTUP_OBJ) $(STARTUP_SRC)
	@echo "Successfully built startup"

elf: $(ELF_FILE)

bin: $(BIN_FILE)

hex: $(HEX_FILE)

clean: 
	rm -f -R ./bin ./obj
