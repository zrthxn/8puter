#!/usr/bin/env python

"""
Convert GNU Unifont format definitions into data statements for GNU as.

Copyright (C) 2017 Paul Boddie <paul@boddie.org.uk>

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program.  If not, see <http://www.gnu.org/licenses/>.
"""

from os.path import split
import sys

def convert_font(fin, fout, points, missing=32):

    """
    Convert the font obtained via 'fin' to an assembly language representation,
    writing to 'fout' the characters for the chosen sequence of 'points'.

    A table of offsets is written to permit each character to be found in the
    generated data.

    If 'missing' is specified, the character of the given value will be used
    for missing character data.
    """

    points.sort()
    base = points[0]
    limit = points[-1]

    # Store the offset of each chosen character.

    table = []
    offset = 0

    # Search for each character until no more remain to be found.

    index = 0
    end = len(points)

    print >>fout, """\
.globl fontchars
.globl fonttable
.globl fontbase
.globl fontlimit

.section .flash, "a"

fontchars:"""

    line = fin.readline()

    while line and index < end:

        # Obtain the code point and data.

        point, data = line.rstrip().split(":")
        point = int(point, 16)

        # Add null offsets for missing characters.

        i = len(table) + base
        while i < point:
            table.append(None)
            i += 1

        # Add a null offset for unselected characters.

        if point < points[index]:
            if point >= base:
                table.append(None)
            line = fin.readline()
            continue

        # Obtain the byte values from the data.

        bytes = []
        i = 0
        while i < len(data):
            bytes.append("0x%s" % data[i:i+2])
            i += 2

        # Add an offset for the character.

        table.append(offset)
        offset += len(bytes)

        # Write the character details.

        print >>fout, "/* %s */" % point
        print >>fout, ".byte", ", ".join(bytes)

        index += 1
        line = fin.readline()

    # Add a final offset to mark the end of the data.

    table.append(offset)

    # Write the offset table.

    print >>fout, """
fonttable:"""

    for offset in table:
        if offset is None:
            offset = table[missing - base]
        print >>fout, ".word %d" % offset

    print >>fout, """
fontbase:
.byte %d

fontlimit:
.byte %d""" % (base, limit)

# Main program.

if __name__ == "__main__":

    # Test options.

    if "--help" in sys.argv or len(sys.argv) < 3:
        basename = split(sys.argv[0])[1]
        print >>sys.stderr, """\
Usage:

%s <input filename> <output filename>
""" % basename
        sys.exit(1)

    base = 32
    points = range(32, 127)

    input_filename, output_filename = sys.argv[1:3]
    fin = open(input_filename)
    fout = open(output_filename, "w")
    try:
        convert_font(fin, fout, points, base)
    finally:
        fin.close()
        fout.close()

# vim: tabstop=4 expandtab shiftwidth=4
