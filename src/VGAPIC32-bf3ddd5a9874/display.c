/*
 * Write to display memory.
 *
 * Copyright (C) 2017 Paul Boddie <paul@boddie.org.uk>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <stdint.h>
#include "mips.h"
#include "vga.h"

/* The font base and limit are locations containing the first and last codes. */

extern uint8_t fontbase, fontlimit;

/* The font character data is a list of bitmap bytes. */

extern uint8_t fontchars;
static uint8_t *fontdata = &fontchars;

/*
The font table is a list of byte-resolution indexes to be combined with the font
character data list address.
*/

extern uint32_t fonttable;
static uint32_t *fontoffsets = &fonttable;



/* Wrap addresses around at the end of the screen area. */

uint32_t *wrap_address(uint32_t *target)
{
	if (target > (uint32_t *) SCREEN_LIMIT_KSEG0)
		return target - SCREEN_SIZE / 4;
	else
		return target;
}

/* Framebuffer initialisation using image data. */

void init_framebuffer(uint32_t *data)
{
	uint32_t *addr = (uint32_t *) SCREEN_BASE_KSEG0;
	uint16_t x, y;

	for (y = 0; y < LINE_COUNT; y++)
	{
		for (x = 0; x < LINE_LENGTH; x += 4)
		{
			*addr = *data;
			addr++;
			data++;
		}
	}
}

/* Framebuffer initialisation using a test pattern. */

void init_framebuffer_with_pattern()
{
	uint32_t *addr = (uint32_t *) SCREEN_BASE_KSEG0;
	uint32_t base, value;
	uint16_t x, y;
	uint8_t row, offset;

	/* For each line in the screen... */

	for (y = 0; y < LINE_COUNT; y++)
	{
		/*
		Start each line with a base value.
		Each byte: 00bbbb00
		*/

		row = y / 16;
		base = (row << 26) | (row << 18) | (row << 10) | (row << 2);

		/*
		Set the intensity bit on every other palette row.
		Each byte: i0bbbb00
		*/

		if (row % 2) base |= 0x80808080;

		/* For each word in the line... */

		for (x = 0; x < LINE_LENGTH; x += 4)
		{
			/*
			Combine the base value with the offset.
			Each byte: i0bbbboo
			*/

			offset = x / 20;
			value = base | (offset << 24) | (offset << 16) | (offset << 8) | offset;

			/* Store the value. */

			*addr = value;

			/* Access the next word. */

			addr++;
		}
	}
}

/* Font-related routines. */

uint8_t *find_char(uint8_t code)
{
	return &fontdata[fontoffsets[code - fontbase]];
}

uint32_t rowdata_to_bitmap(uint8_t rowdata, uint8_t mask, uint8_t mask_limit)
{
	uint32_t output = 0;

	while (mask != mask_limit)
	{
		output = output >> 8;
		if (rowdata & mask)
			output |= 0xff000000;
		mask = mask >> 1;
	}

	return output;
}

void blit_char(uint8_t code, uint32_t *target)
{
	/* Get the source address of the character data. */

	uint8_t *source = find_char(code);

	/* Get the limit of the character data. */

	uint8_t *limit = find_char(code + 1);
	uint8_t rowdata;

	/*
	Read each byte of the character data, representing a row of bitmap
	cells.
	*/

	while (source < limit)
	{
		rowdata = *source;

		/*
		Write two consecutive words, one for the upper four bits of the
		data, one for the lower four bits of the data.

		For each bit, produce an "on" or "off" byte for the bitmap cell.
		*/

		*target = rowdata_to_bitmap(rowdata, 0x80, 0x08);
		*(wrap_address(target + 1)) = rowdata_to_bitmap(rowdata, 0x08, 0x00);

		/* Move on to the next line. The arithmetic employs words. */

		target = wrap_address(target + LINE_LENGTH / 4);

		/* Move on to the next data byte. */

		source++;
	}
}

uint32_t *char_address(uint32_t *base, uint8_t x, uint8_t y)
{
	return wrap_address(base + (x * 2) + (y * LINE_LENGTH / 4));
}

void blit_string(uint8_t *source, uint32_t *target)
{
	uint8_t c;

	/* Read byte values until a zero is found. */

	while ((c = *source) != 0)
	{
		blit_char(c, target);
		source++;

		/* Move across eight pixels (two words). */

		target = wrap_address(target + 2);
	}
}
