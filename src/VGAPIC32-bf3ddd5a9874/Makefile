# Makefile - Build the PIC32 VGA payload
#
# Copyright (C) 2015, 2017 Paul Boddie <paul@boddie.org.uk>
# Copyright (C) Xiangfu Liu <xiangfu@sharism.cc>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

ARCH = mipsel-linux-gnu
CC = $(ARCH)-gcc
LD = $(ARCH)-ld
NM = $(ARCH)-nm
OBJCOPY=$(ARCH)-objcopy
OBJDUMP=$(ARCH)-objdump

# NOTE: -O2 is actually needed to prevent memcpy references, whereas probably
# NOTE: one of the -f{freestanding, no-hosted, no-builtin} options should work.
# NOTE: See: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=56888

CFLAGS = -O2 -Wall \
	-fno-unit-at-a-time -fno-zero-initialized-in-bss \
	-ffreestanding -fno-hosted -fno-builtin \
	-march=mips32
LDFLAGS = -nostdlib -EL

TARGET = vga.elf
DUMP = $(TARGET:.elf=.dump)
MAP = $(TARGET:.elf=.map)
SCRIPT = $(TARGET:.elf=.ld)

HEX = $(TARGET:.elf=.hex)
SREC = $(TARGET:.elf=.srec)

# Ordering of objects is important and cannot be left to replacement rules.

SRC = vga.S display.c screendata.S fontdata.S chardata.S
OBJ = vga.o display.o screendata.o fontdata.o chardata.o

.PHONY:	all clean distclean

all:	$(HEX) $(SREC)

clean:
	rm -f $(OBJ) $(TARGET) $(HEX) $(SREC) $(DUMP) *.map

distclean: clean
	echo "Nothing else to clean."

$(HEX): $(TARGET)
	$(OBJCOPY) -O ihex $(TARGET) $(HEX)

$(SREC): $(TARGET)
	$(OBJCOPY) -O srec $(TARGET) $(SREC)

$(TARGET): $(OBJ)
	$(LD) $(LDFLAGS) -T $(SCRIPT) $(OBJ) -o $@
	$(OBJDUMP) -D $(TARGET) > $(DUMP)
	$(OBJDUMP) -h $(TARGET) > $(MAP)
	$(NM) -n $(TARGET) > System.map

.c.o:
	$(CC) -c $(CFLAGS) $< -o $@

.S.o:
	$(CC) -c $(CFLAGS) $< -o $@
