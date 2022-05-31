	.arch armv8-a
//	BubbleSort
	.data
	.align	3
n:
	.quad	10
mas:
	.quad	8, 7, 1, 9, 5, 2, 6, 0, 4, 3
	.text
	.align	2
	.global _start
	.type	_start, %function
_start:
	adr	x0, n
	ldr	x0, [x0]
	adr	x1, mas
	mov	x2, x0
L0:
	sub	x2, x2, #1
	cbz	x2, L4
	mov	x3, #0
	ldr	x5, [x1]
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
