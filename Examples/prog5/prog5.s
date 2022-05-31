	.arch armv8-a
//	BubbleSort with flag
	.data
	.align	3
n:
	.quad	10
mas:
	.quad	0, 1, 2, 8, 7, 9, 5, 6, 4, 3
	.text
	.align	2
	.global _start
	.type	_start, %function
_start:
	adr	x0, n
	ldr	x0, [x0]
	adr	x1, mas
	mov	x2, x0
	mov	x7, #1
L0:
	cbz	x7, L4
	sub	x2, x2, #1
	cbz	x2, L4
	mov	x7, #0
	mov	x3, #0
	ldr	x5, [x1, x3, lsl #3]
L1:
	add	x4, x3, #1
	cmp	x4, x2
	bgt	L0
	ldr	x6, [x1, x4, lsl #3]
	cmp	x5, x6
	blt	L2
	beq	L3
	str	x5, [x1, x4, lsl #3]
	str	x6, [x1, x3, lsl #3]
	mov	x7, #1
	b	L3
L2:
	mov	x5, x6
L3:
	add	x3, x3, #1
	b	L1
L4:
	mov	x0, #0
	mov	x8, #93
	svc	#0
	.size	_start, .-_start
