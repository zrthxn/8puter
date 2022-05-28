#ifndef __VGA_H__
#define __VGA_H__

#define LINE_LENGTH	160				/* pixels */
#define LINE_COUNT	256				/* distinct display lines */

#define HFREQ_LIMIT	643				/* 24MHz cycles */
#define HSYNC_START	460				/* 24MHz cycles */
#define HSYNC_LIMIT	64				/* 24MHz cycles */
#define HSYNC_END	(HSYNC_START + HSYNC_LIMIT)

#define VISIBLE_START	70				/* horizontal lines, back porch end */
#define VFP_START	(VISIBLE_START + 2 * LINE_COUNT)
#define VSYNC_START	620				/* horizontal lines, front porch end */
#define VSYNC_END	622				/* horizontal lines, back porch start */

#define SCREEN_BASE	256
#define SCREEN_SIZE	(40 * 1024)
#define SCREEN_LIMIT	(SCREEN_BASE + SCREEN_SIZE)

#define SCREEN_BASE_KSEG0	(KSEG0_BASE + SCREEN_BASE)
#define SCREEN_LIMIT_KSEG0	(KSEG0_BASE + SCREEN_LIMIT)

#define IRQ_STACK_LIMIT		SCREEN_BASE_KSEG0
#define IRQ_STACK_TOP		(IRQ_STACK_LIMIT - 64)

#endif /* __VGA_H__ */
