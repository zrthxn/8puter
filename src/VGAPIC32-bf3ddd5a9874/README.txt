Introduction
------------

The VGAPIC32 project provides software and circuit information to generate an
analogue VGA signal from a PIC32 microcontroller. More details can be found in
the following article:

http://blogs.fsfe.org/pboddie/?p=1712

See also the docs directory for original versions of the different explanatory
diagrams.

Contact, Copyright and Licence Information
------------------------------------------

The author can be contacted at the following e-mail address:

paul@boddie.org.uk

Copyright and licence information can be found in the docs directory - see
docs/COPYING.txt and docs/gpl-3.0.txt for more information.



Hardware Details
================

The pin usage of this solution is documented below.

PIC32MX270F256B-50I/SP Pin Assignments
--------------------------------------

MCLR#          1  \/  28
HSYNC/OC1/RA0  2      27
VSYNC/OC2/RA1  3      26 RB15
       D0/RB0  4      25 RB14
       D1/RB1  5      24 RB13
       D2/RB2  6      23
       D3/RB3  7      22 RB11/PGEC2
               8      21 RB10/PGEC3
          RA2  9      20
          RA3 10      19
       D4/RB4 11      18 RB9
              12      17 RB8
              13      16 RB7/D7
       D5/RB5 14      15

Note that RB6 is not available on pin 15 on this device.

Data Signal Routing
-------------------

For one bit of intensity, two bits per colour channel:

D7 -> 2200R -> I

I -> diode -> R
I -> diode -> G
I -> diode -> B

D6 (not connected)

D5 -> 470R -> R
D4 -> 1000R -> R
D3 -> 470R -> G
D2 -> 1000R -> G
D1 -> 470R -> B
D0 -> 1000R -> B

HSYNC -> HS
VSYNC -> VS

Output Socket Pinout
--------------------

  5 (GND)  4 (NC)   3 (B)    2 (G)    1 (R)

      10 (GND) 9 (NC)   8 (GND)  7 (GND)  6 (GND)

  15 (NC)  14 (VS)  13 (HS)  12 (NC)  11 (NC)

Output Cable Pinout
-------------------

      1 (R)    2 (G)    3 (B)    4 (NC)   5 (GND)

  6 (GND)  7 (GND)  8 (GND)  9 (NC)   10 (GND)

      11 (NC)  12 (NC)  13 (HS)  14 (VS)  15 (NC)

References
----------

https://en.wikipedia.org/wiki/VGA_connector

http://papilio.cc/index.php?n=Papilio.VGAWing

http://lucidscience.com/pro-vga%20video%20generator-2.aspx

https://sites.google.com/site/h2obsession/CBM/C128/rgbi-to-vga
