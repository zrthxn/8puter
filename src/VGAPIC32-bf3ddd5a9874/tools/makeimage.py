#!/usr/bin/env python

"""
Convert images for display in an Acorn Electron MODE 2 variant with a pixel
layout of I0RRGGBB, giving 128 colours instead of the usual 8 colours.

Copyright (C) 2015, 2017 Paul Boddie <paul@boddie.org.uk>

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

from os.path import split, splitext
import EXIF
import PIL.Image
import sys

def convert_image(im, output_filename, width, height):

    "Convert 'im' and write pixel values to 'output_filename'."

    w, h = im.size

    hpad = (width - w) / 2
    leftpad = hpad; rightpad = width - w - hpad
    vpad = (height - h) / 2
    toppad = vpad; bottompad = height - h - vpad

    data = iter(im.getdata())

    f = open(output_filename, "w")
    try:
        print >>f, """\
.globl screendata

.section .flash, "a"
"""

        word = []
        y = 0

        while y < height:
            x = 0

            # Top and bottom padding.

            if y < toppad or y >= height - bottompad:

                while x < width:
                    word.append(0)
                    flush_word(f, word)
                    x += 1

                flush_last_word(f, word)

            # Lines with data.

            else:
                while x < width:

                    # Left and right padding.

                    if x < leftpad or x >= width - rightpad:
                        word.append(0)

                    # Data regions.

                    else:
                        r, g, b = data.next()
                        rm, gm, bm, i = get_values(r, g, b)

                        # Encode the byte value: I0RRGGBB.

                        word.insert(0,
                            # I -> D<7>
                            (i << 7) |
                            # R<7:6> -> D<5:4>
                            (rm >> 2) |
                            # G<7:6> -> D<3:2>
                            (gm >> 4) |
                            # B<7:6> -> D<1:0>
                            (bm >> 6))

                    flush_word(f, word)
                    x += 1

                flush_last_word(f, word)

            y += 1

    finally:
        f.close()

def get_values(r, g, b):

    "Return modified values for 'r', 'g' and 'b', plus an intensity bit."

    rm = r & 0xc0
    gm = g & 0xc0
    bm = b & 0xc0
    rd = r - rm
    gd = g - gm
    bd = b - bm
    i = ((rd ** 2 + gd ** 2 + bd ** 2) ** 0.5) >= 32 and 1 or 0
    return rm, gm, bm, i

def make_preview(im):
    imp = PIL.Image.new("RGB", im.size)
    data = []
    for r, g, b in im.getdata():
        rm, gm, bm, i = get_values(r, g, b)
        r = rm + (i * 32)
        g = gm + (i * 32)
        b = bm + (i * 32)
        data.append((r, g, b))
    imp.putdata(data)
    return imp

def flush_last_word(f, word):
    if word:
        pad_word(word)
        write_word(f, word)
        del word[:]

def flush_word(f, word):
    if len(word) == 4:
        write_word(f, word)
        del word[:]

def pad_word(word):
    while len(word) < 4:
        word.insert(0, 0)

def write_word(f, word):
    print >>f, ".word 0x%02x%02x%02x%02x" % tuple(word)

def rotate_and_scale(exif, im, width, height, rotate, scale_factor):

    """
    Using the given 'exif' information, rotate and scale image 'im' given the
    indicated 'width' and 'height' constraints and any explicit 'rotate'
    indication. The returned image will be within the given 'width' and
    'height', filling either or both, and preserve its original aspect ratio.
    """

    if rotate or exif and exif["Image Orientation"].values == [6L]:
        im = im.rotate(270)

    w, h = im.size

    # Get the relationship between the base width and the image width.

    width_scale_factor = (width / scale_factor) / w
    height_scale_factor = float(height) / h
    min_scale_factor = min(width_scale_factor, height_scale_factor)

    if min_scale_factor < 1:
        width = int(min_scale_factor * w * scale_factor)
        height = int(min_scale_factor * h)
        return im.resize((width, height))
    elif scale_factor != 1:
        width = int(w * scale_factor)
        return im.resize((width, h))
    else:
        return im

def get_parameter(options, flag, conversion, default, missing):

    """
    From 'options', return any parameter following the given 'flag', applying
    the 'conversion' which has the given 'default' if no valid parameter is
    found, or returning the given 'missing' value if the flag does not appear at
    all.
    """

    try:
        i = options.index(flag)
        try:
            return conversion(options[i+1])
        except (IndexError, ValueError):
            return default
    except ValueError:
        return missing

# Main program.

if __name__ == "__main__":

    # Test options.

    if "--help" in sys.argv or len(sys.argv) < 3:
        basename = split(sys.argv[0])[1]
        print >>sys.stderr, """\
Usage:

%s <input filename> <output filename> [ <options> ]

Options are...

-W - Indicate the output width (default is 160)

-p - Generate a preview with a filename based on the output filename

-r - Rotate the input image clockwise explicitly
     (EXIF information is used otherwise)
""" % basename
        sys.exit(1)

    base_width = 320; width = 160
    base_height = height = 256

    input_filename, output_filename = sys.argv[1:3]
    options = sys.argv[3:]

    # Basic image properties.

    width = get_parameter(options, "-W", int, width, width)
    rotate = "-r" in options
    preview = "-p" in options

    # Determine any differing horizontal scale factor.

    scale_factor = float(width) / base_width

    # Load the input image.

    exif = EXIF.process_file(open(input_filename))
    im = PIL.Image.open(input_filename).convert("RGB")
    im = rotate_and_scale(exif, im, width, height, rotate, scale_factor)

    # Generate an output image.

    convert_image(im, output_filename, width, height)

    # Generate a preview image if requested.

    if preview:
        _basename, ext = splitext(input_filename)
        basename, _ext = splitext(output_filename)
        preview_filename = "%s_preview%s" % (basename, ext)
        imp = make_preview(im)
        imp.save(preview_filename)

# vim: tabstop=4 expandtab shiftwidth=4
