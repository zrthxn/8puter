.globl fontchars
.globl fonttable
.globl fontbase
.globl fontlimit

.section .flash, "a"

fontchars:
/* 32 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
/* 33 */
.byte 0x00, 0x00, 0x00, 0x00, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x00, 0x08, 0x08, 0x00, 0x00
/* 34 */
.byte 0x00, 0x00, 0x22, 0x22, 0x22, 0x22, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
/* 35 */
.byte 0x00, 0x00, 0x00, 0x00, 0x12, 0x12, 0x12, 0x7E, 0x24, 0x24, 0x7E, 0x48, 0x48, 0x48, 0x00, 0x00
/* 36 */
.byte 0x00, 0x00, 0x00, 0x00, 0x08, 0x3E, 0x49, 0x48, 0x38, 0x0E, 0x09, 0x49, 0x3E, 0x08, 0x00, 0x00
/* 37 */
.byte 0x00, 0x00, 0x00, 0x00, 0x31, 0x4A, 0x4A, 0x34, 0x08, 0x08, 0x16, 0x29, 0x29, 0x46, 0x00, 0x00
/* 38 */
.byte 0x00, 0x00, 0x00, 0x00, 0x1C, 0x22, 0x22, 0x14, 0x18, 0x29, 0x45, 0x42, 0x46, 0x39, 0x00, 0x00
/* 39 */
.byte 0x00, 0x00, 0x08, 0x08, 0x08, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
/* 40 */
.byte 0x00, 0x00, 0x00, 0x04, 0x08, 0x08, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x08, 0x08, 0x04, 0x00
/* 41 */
.byte 0x00, 0x00, 0x00, 0x20, 0x10, 0x10, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x10, 0x10, 0x20, 0x00
/* 42 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x49, 0x2A, 0x1C, 0x2A, 0x49, 0x08, 0x00, 0x00, 0x00
/* 43 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x08, 0x08, 0x7F, 0x08, 0x08, 0x08, 0x00, 0x00, 0x00
/* 44 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x18, 0x08, 0x08, 0x10
/* 45 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
/* 46 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x18, 0x18, 0x00, 0x00
/* 47 */
.byte 0x00, 0x00, 0x00, 0x00, 0x02, 0x02, 0x04, 0x08, 0x08, 0x10, 0x10, 0x20, 0x40, 0x40, 0x00, 0x00
/* 48 */
.byte 0x00, 0x00, 0x00, 0x00, 0x18, 0x24, 0x42, 0x46, 0x4A, 0x52, 0x62, 0x42, 0x24, 0x18, 0x00, 0x00
/* 49 */
.byte 0x00, 0x00, 0x00, 0x00, 0x08, 0x18, 0x28, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x3E, 0x00, 0x00
/* 50 */
.byte 0x00, 0x00, 0x00, 0x00, 0x3C, 0x42, 0x42, 0x02, 0x0C, 0x10, 0x20, 0x40, 0x40, 0x7E, 0x00, 0x00
/* 51 */
.byte 0x00, 0x00, 0x00, 0x00, 0x3C, 0x42, 0x42, 0x02, 0x1C, 0x02, 0x02, 0x42, 0x42, 0x3C, 0x00, 0x00
/* 52 */
.byte 0x00, 0x00, 0x00, 0x00, 0x04, 0x0C, 0x14, 0x24, 0x44, 0x44, 0x7E, 0x04, 0x04, 0x04, 0x00, 0x00
/* 53 */
.byte 0x00, 0x00, 0x00, 0x00, 0x7E, 0x40, 0x40, 0x40, 0x7C, 0x02, 0x02, 0x02, 0x42, 0x3C, 0x00, 0x00
/* 54 */
.byte 0x00, 0x00, 0x00, 0x00, 0x1C, 0x20, 0x40, 0x40, 0x7C, 0x42, 0x42, 0x42, 0x42, 0x3C, 0x00, 0x00
/* 55 */
.byte 0x00, 0x00, 0x00, 0x00, 0x7E, 0x02, 0x02, 0x04, 0x04, 0x04, 0x08, 0x08, 0x08, 0x08, 0x00, 0x00
/* 56 */
.byte 0x00, 0x00, 0x00, 0x00, 0x3C, 0x42, 0x42, 0x42, 0x3C, 0x42, 0x42, 0x42, 0x42, 0x3C, 0x00, 0x00
/* 57 */
.byte 0x00, 0x00, 0x00, 0x00, 0x3C, 0x42, 0x42, 0x42, 0x3E, 0x02, 0x02, 0x02, 0x04, 0x38, 0x00, 0x00
/* 58 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x18, 0x18, 0x00, 0x00, 0x00, 0x18, 0x18, 0x00, 0x00, 0x00
/* 59 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x18, 0x18, 0x00, 0x00, 0x00, 0x18, 0x08, 0x08, 0x10, 0x00
/* 60 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x04, 0x08, 0x10, 0x20, 0x10, 0x08, 0x04, 0x02, 0x00, 0x00
/* 61 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x7E, 0x00, 0x00, 0x00, 0x7E, 0x00, 0x00, 0x00, 0x00
/* 62 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x20, 0x10, 0x08, 0x04, 0x08, 0x10, 0x20, 0x40, 0x00, 0x00
/* 63 */
.byte 0x00, 0x00, 0x00, 0x00, 0x3C, 0x42, 0x42, 0x02, 0x04, 0x08, 0x08, 0x00, 0x08, 0x08, 0x00, 0x00
/* 64 */
.byte 0x00, 0x00, 0x00, 0x00, 0x1C, 0x22, 0x4A, 0x56, 0x52, 0x52, 0x52, 0x4E, 0x20, 0x1E, 0x00, 0x00
/* 65 */
.byte 0x00, 0x00, 0x00, 0x00, 0x18, 0x24, 0x24, 0x42, 0x42, 0x7E, 0x42, 0x42, 0x42, 0x42, 0x00, 0x00
/* 66 */
.byte 0x00, 0x00, 0x00, 0x00, 0x7C, 0x42, 0x42, 0x42, 0x7C, 0x42, 0x42, 0x42, 0x42, 0x7C, 0x00, 0x00
/* 67 */
.byte 0x00, 0x00, 0x00, 0x00, 0x3C, 0x42, 0x42, 0x40, 0x40, 0x40, 0x40, 0x42, 0x42, 0x3C, 0x00, 0x00
/* 68 */
.byte 0x00, 0x00, 0x00, 0x00, 0x78, 0x44, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x44, 0x78, 0x00, 0x00
/* 69 */
.byte 0x00, 0x00, 0x00, 0x00, 0x7E, 0x40, 0x40, 0x40, 0x7C, 0x40, 0x40, 0x40, 0x40, 0x7E, 0x00, 0x00
/* 70 */
.byte 0x00, 0x00, 0x00, 0x00, 0x7E, 0x40, 0x40, 0x40, 0x7C, 0x40, 0x40, 0x40, 0x40, 0x40, 0x00, 0x00
/* 71 */
.byte 0x00, 0x00, 0x00, 0x00, 0x3C, 0x42, 0x42, 0x40, 0x40, 0x4E, 0x42, 0x42, 0x46, 0x3A, 0x00, 0x00
/* 72 */
.byte 0x00, 0x00, 0x00, 0x00, 0x42, 0x42, 0x42, 0x42, 0x7E, 0x42, 0x42, 0x42, 0x42, 0x42, 0x00, 0x00
/* 73 */
.byte 0x00, 0x00, 0x00, 0x00, 0x3E, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x3E, 0x00, 0x00
/* 74 */
.byte 0x00, 0x00, 0x00, 0x00, 0x1F, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x44, 0x44, 0x38, 0x00, 0x00
/* 75 */
.byte 0x00, 0x00, 0x00, 0x00, 0x42, 0x44, 0x48, 0x50, 0x60, 0x60, 0x50, 0x48, 0x44, 0x42, 0x00, 0x00
/* 76 */
.byte 0x00, 0x00, 0x00, 0x00, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x7E, 0x00, 0x00
/* 77 */
.byte 0x00, 0x00, 0x00, 0x00, 0x42, 0x42, 0x66, 0x66, 0x5A, 0x5A, 0x42, 0x42, 0x42, 0x42, 0x00, 0x00
/* 78 */
.byte 0x00, 0x00, 0x00, 0x00, 0x42, 0x62, 0x62, 0x52, 0x52, 0x4A, 0x4A, 0x46, 0x46, 0x42, 0x00, 0x00
/* 79 */
.byte 0x00, 0x00, 0x00, 0x00, 0x3C, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x3C, 0x00, 0x00
/* 80 */
.byte 0x00, 0x00, 0x00, 0x00, 0x7C, 0x42, 0x42, 0x42, 0x7C, 0x40, 0x40, 0x40, 0x40, 0x40, 0x00, 0x00
/* 81 */
.byte 0x00, 0x00, 0x00, 0x00, 0x3C, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x5A, 0x66, 0x3C, 0x03, 0x00
/* 82 */
.byte 0x00, 0x00, 0x00, 0x00, 0x7C, 0x42, 0x42, 0x42, 0x7C, 0x48, 0x44, 0x44, 0x42, 0x42, 0x00, 0x00
/* 83 */
.byte 0x00, 0x00, 0x00, 0x00, 0x3C, 0x42, 0x42, 0x40, 0x30, 0x0C, 0x02, 0x42, 0x42, 0x3C, 0x00, 0x00
/* 84 */
.byte 0x00, 0x00, 0x00, 0x00, 0x7F, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x00, 0x00
/* 85 */
.byte 0x00, 0x00, 0x00, 0x00, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x3C, 0x00, 0x00
/* 86 */
.byte 0x00, 0x00, 0x00, 0x00, 0x41, 0x41, 0x41, 0x22, 0x22, 0x22, 0x14, 0x14, 0x08, 0x08, 0x00, 0x00
/* 87 */
.byte 0x00, 0x00, 0x00, 0x00, 0x42, 0x42, 0x42, 0x42, 0x5A, 0x5A, 0x66, 0x66, 0x42, 0x42, 0x00, 0x00
/* 88 */
.byte 0x00, 0x00, 0x00, 0x00, 0x42, 0x42, 0x24, 0x24, 0x18, 0x18, 0x24, 0x24, 0x42, 0x42, 0x00, 0x00
/* 89 */
.byte 0x00, 0x00, 0x00, 0x00, 0x41, 0x41, 0x22, 0x22, 0x14, 0x08, 0x08, 0x08, 0x08, 0x08, 0x00, 0x00
/* 90 */
.byte 0x00, 0x00, 0x00, 0x00, 0x7E, 0x02, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x40, 0x7E, 0x00, 0x00
/* 91 */
.byte 0x00, 0x00, 0x00, 0x0E, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x0E, 0x00
/* 92 */
.byte 0x00, 0x00, 0x00, 0x00, 0x40, 0x40, 0x20, 0x10, 0x10, 0x08, 0x08, 0x04, 0x02, 0x02, 0x00, 0x00
/* 93 */
.byte 0x00, 0x00, 0x00, 0x70, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x70, 0x00
/* 94 */
.byte 0x00, 0x00, 0x18, 0x24, 0x42, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
/* 95 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x7F, 0x00
/* 96 */
.byte 0x00, 0x20, 0x10, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
/* 97 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3C, 0x42, 0x02, 0x3E, 0x42, 0x42, 0x46, 0x3A, 0x00, 0x00
/* 98 */
.byte 0x00, 0x00, 0x00, 0x40, 0x40, 0x40, 0x5C, 0x62, 0x42, 0x42, 0x42, 0x42, 0x62, 0x5C, 0x00, 0x00
/* 99 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3C, 0x42, 0x40, 0x40, 0x40, 0x40, 0x42, 0x3C, 0x00, 0x00
/* 100 */
.byte 0x00, 0x00, 0x00, 0x02, 0x02, 0x02, 0x3A, 0x46, 0x42, 0x42, 0x42, 0x42, 0x46, 0x3A, 0x00, 0x00
/* 101 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3C, 0x42, 0x42, 0x7E, 0x40, 0x40, 0x42, 0x3C, 0x00, 0x00
/* 102 */
.byte 0x00, 0x00, 0x00, 0x0C, 0x10, 0x10, 0x10, 0x7C, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x00, 0x00
/* 103 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x3A, 0x44, 0x44, 0x44, 0x38, 0x20, 0x3C, 0x42, 0x42, 0x3C
/* 104 */
.byte 0x00, 0x00, 0x00, 0x40, 0x40, 0x40, 0x5C, 0x62, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x00, 0x00
/* 105 */
.byte 0x00, 0x00, 0x00, 0x08, 0x08, 0x00, 0x18, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x3E, 0x00, 0x00
/* 106 */
.byte 0x00, 0x00, 0x00, 0x04, 0x04, 0x00, 0x0C, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x48, 0x30
/* 107 */
.byte 0x00, 0x00, 0x00, 0x40, 0x40, 0x40, 0x44, 0x48, 0x50, 0x60, 0x50, 0x48, 0x44, 0x42, 0x00, 0x00
/* 108 */
.byte 0x00, 0x00, 0x00, 0x18, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x3E, 0x00, 0x00
/* 109 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x76, 0x49, 0x49, 0x49, 0x49, 0x49, 0x49, 0x49, 0x00, 0x00
/* 110 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x5C, 0x62, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x00, 0x00
/* 111 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3C, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x3C, 0x00, 0x00
/* 112 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x5C, 0x62, 0x42, 0x42, 0x42, 0x42, 0x62, 0x5C, 0x40, 0x40
/* 113 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3A, 0x46, 0x42, 0x42, 0x42, 0x42, 0x46, 0x3A, 0x02, 0x02
/* 114 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x5C, 0x62, 0x42, 0x40, 0x40, 0x40, 0x40, 0x40, 0x00, 0x00
/* 115 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3C, 0x42, 0x40, 0x30, 0x0C, 0x02, 0x42, 0x3C, 0x00, 0x00
/* 116 */
.byte 0x00, 0x00, 0x00, 0x00, 0x10, 0x10, 0x10, 0x7C, 0x10, 0x10, 0x10, 0x10, 0x10, 0x0C, 0x00, 0x00
/* 117 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x46, 0x3A, 0x00, 0x00
/* 118 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x42, 0x42, 0x42, 0x24, 0x24, 0x24, 0x18, 0x18, 0x00, 0x00
/* 119 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x41, 0x49, 0x49, 0x49, 0x49, 0x49, 0x49, 0x36, 0x00, 0x00
/* 120 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x42, 0x42, 0x24, 0x18, 0x18, 0x24, 0x42, 0x42, 0x00, 0x00
/* 121 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x42, 0x42, 0x42, 0x42, 0x42, 0x26, 0x1A, 0x02, 0x02, 0x3C
/* 122 */
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x7E, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x7E, 0x00, 0x00
/* 123 */
.byte 0x00, 0x00, 0x00, 0x0C, 0x10, 0x10, 0x08, 0x08, 0x10, 0x20, 0x10, 0x08, 0x08, 0x10, 0x10, 0x0C
/* 124 */
.byte 0x00, 0x00, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08
/* 125 */
.byte 0x00, 0x00, 0x00, 0x30, 0x08, 0x08, 0x10, 0x10, 0x08, 0x04, 0x08, 0x10, 0x10, 0x08, 0x08, 0x30
/* 126 */
.byte 0x00, 0x00, 0x00, 0x31, 0x49, 0x46, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

fonttable:
.word 0
.word 16
.word 32
.word 48
.word 64
.word 80
.word 96
.word 112
.word 128
.word 144
.word 160
.word 176
.word 192
.word 208
.word 224
.word 240
.word 256
.word 272
.word 288
.word 304
.word 320
.word 336
.word 352
.word 368
.word 384
.word 400
.word 416
.word 432
.word 448
.word 464
.word 480
.word 496
.word 512
.word 528
.word 544
.word 560
.word 576
.word 592
.word 608
.word 624
.word 640
.word 656
.word 672
.word 688
.word 704
.word 720
.word 736
.word 752
.word 768
.word 784
.word 800
.word 816
.word 832
.word 848
.word 864
.word 880
.word 896
.word 912
.word 928
.word 944
.word 960
.word 976
.word 992
.word 1008
.word 1024
.word 1040
.word 1056
.word 1072
.word 1088
.word 1104
.word 1120
.word 1136
.word 1152
.word 1168
.word 1184
.word 1200
.word 1216
.word 1232
.word 1248
.word 1264
.word 1280
.word 1296
.word 1312
.word 1328
.word 1344
.word 1360
.word 1376
.word 1392
.word 1408
.word 1424
.word 1440
.word 1456
.word 1472
.word 1488
.word 1504
.word 1520

fontbase:
.byte 32

fontlimit:
.byte 126
