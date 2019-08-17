# STM32F10x-Makefile
A template project with makefile for STM32F10x devices

## Directories
    STM32_Project_Template
    |
    |-- lib
    |   |-- devices
    |       |-- md
    |       |   |-- stm32f10x_conf.h
    |       |   |-- stm32_flash.ld
    |       |
    |       |-- hd
    |
    |-- src
    |   |-- lib
    |   |   |-- led.h
    |   |   |-- led.c
    |   |   |-- init.h
    |   |   |-- init.c
    |   |   |-- or other files .c/.h
    |   |
    |   |-- main.c
    |   |-- stm32f10x_it.c
    |   |-- or other files .c/.h
    |   
    |-- Makefile

## How-to
It's really easy to use for STM32 starters.
### 1 Create source files
First, put the Source Files into `src`.
### 2 Change Makefile Settings
**Project Name**
In the first line of configuration, you can set a project name. The targets will be named by this.
(eg. Set `project_name = my_stm_project` and you will finally get `my_stm_project.hex`)
**Device volume**
The second configuration is to choose a volume of this device. You can set this field to `cl hd hd_vl ld ld_vl md md_vl xl`. This setting will be used to find startup file.
(eg. Set `device_vol = md` and Makefile will find `startup_stm32f10x_md.s` in CMSIS library. Also, Makefile will define STM32F10X_ML during compilation.)
**Cross-compiler root**
Define `compiler_root` to tell Makefile which compiler will be used.
(eg. `compiler_root = /home/Downloads/gcc-arm-none-eabi-8-2019-q3-update`)
**Note:** If you installed `arm-none-eabi-gcc` in your system, you can empty this field or directly set: (Line 40)
    ARMCC = arm-none-eabi-gcc
**StdPeriph Library root**
Define this to tell Makefile where to find library files like `core_cm3.c stm32f10x_gpio.h`
(eg. `StdPeriph_root = /home/johnson/Downloads/STM32F10x_StdPeriph_Lib_V3.5.0`)
### 3 Start making files
When all these configurations done, you can `cd` into your project directory, run:
    make
If no error occur, targets will be created in `bin`. It creats three files by default: `elf`, `hex` and `bin`.
To create elf only: `make elf`
To create hex only: `make hex`
To create bin only: `make bin`
To clean the build: (delete `bin` and `obj`): `make clean`

enjoy :-)
