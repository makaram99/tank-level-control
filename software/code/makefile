############################################################
# Author		: Mahmoud Karam
# Version		: 2
# Description	: makefile for PIC microcontrollers:
#					* Build Process: <make all>
#						Folder structure:
#							* src 		folder has source files.
#							* include 	folder has header files.
#							* lib 		folder has libraaries files.
#							IF YOU WANT ANOTHER NAME FOR THESE FOLDERS, CHANGE MACROS BELOW (SDIR, HDIR, LDIR)
#					* Write/Read from MCU Flash: <make flash>/<make read>
#					* Read MCU fuse: <make rfuse> 
#					* Clean Binaries & Output Files <make clean>
#						used if makefile has any changes or when 
#						making version control.
#					* Project creation: <make project>
#						pass project name to make: <NAME=test>
#					* Create driver folder: <make driver>
#						pass driver name to make: <NAME=test>
############################################################

############################################################
#					Configurations
############################################################
# Host Configurations
SHELL 	= cmd
RM		= del /s /q
RMDIR	= rmdir /s /q
# Note: / is used with GCC as it's linux SW.
# Note: \ is used with Windows, So, if working on Linux,
#		assume changing \ to / in Windows commands or paths

# Name of the project to use with <make create>
NAME	= Test

# Files directories
SDIR	= src
ODIR 	= obj
HDIR	= include
DDIR	= dep
debugDIR= debug
LDIR	= lib

SRCS	= ${wildcard ${SDIR}/*.c}
OBJS 	= ${SRCS:${SDIR}/%.c=${ODIR}/%.obj}
DEPS 	= ${SRCS:${SDIR}/%.c=${DDIR}/%.d}
-include ${DEPS}

# Target configurations, compiler flags and dependencies flags
TARGET 	= app.hex
FCPU	= 8000000UL
# compiler configurations
CC 		= xc8
CFLAGS	= -c -O1 -Wall -Wextra -std=c99 -pedantic -Wundef -Wunused-macros -Wcast-align -Wlogical-op -fno-common 
EXTRACFLAGS = -wtraditional -Wdangling-pointer -Wfloat-conversion -Wsizeof-array-div -Wsizeof-pointer-div -fno-short-enum -Wtraditional-conversion -Wconversion
DBGFLAGS = -g3

MCU		= 16F877A
LIBS	= -lm

# Tools options
OBJCOPY_FLAGS= -j .text -j .data -j .bss -j .rdata 
SIZE_SW	= ${CC:%gcc=%size}

#Burner SW Configurations
BURN_SW	= avrdude
DUDE_MCU= m128
PRGRMR	= usbasp
PORT	= usb
BAUDRATE= 115200

############################################################
#					Building Rules
############################################################
.PHONY	: all
all 	: ${TARGET}

${TARGET} : makeDirs ${OBJS}
	${CC} --chip=${MCU} ${OBJS} -O@ -Xlinker -M=${@:%.hex=${debugDIR}/%.map} --OUTPUT=intel
	
	${SIZE_SW} -B ${@:%.hex=${debugDIR}/%.bin}
	
.PHONY	: makeDirs
makeDirs:
	@-mkdir ${ODIR} ${DDIR} ${debugDIR}
	
${ODIR}/%.obj : ${SDIR}/%.c 
	${CC} -chip=${MCU} ${CFLAGS} -I "${HDIR}" -V -DF_CPU=${FCPU} --DEBUGGER=pickit3 \
	$< -o $@ ${LIBS} --DEP=gcc --ECHO --FLOAT=32 --LANG=en 
	
.PHONY	: flash
flash:
	${BURN_SW} -c ${PRGRMR} -p ${DUDE_MCU} -P ${PORT} -F -V -U flash:w:${TARGET}:i 
	
.PHONY	: read
read:
	${BURN_SW} -c ${PRGRMR} -p ${DUDE_MCU} -P ${PORT} -F \
	-U flash:r:${TARGET:%.hex=%_read.hex}:i -b ${BAUDRATE}

.PHONY	: rfuse
rfuse:	
	${BURN_SW} -c ${PRGRMR} -p ${DUDE_MCU} -P ${PORT} -F -v -b ${BAUDRATE}

.PHONY 	: clean
clean	:			
#	${RM} ${TARGET:%.hex=%.*} ${ODIR}\* ${DDIR}\* ${SDIR}\*~ \
#	${HDIR}\*~ ${debugDIR}\*
	${RMDIR} ${ODIR} ${DDIR} ${debugDIR}
	${RM} ${TARGET}  ${SDIR}\*~ ${HDIR}\*~ *.su

