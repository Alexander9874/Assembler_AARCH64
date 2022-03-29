	.arch armv8-a
//	SelectonSort
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
	sub	x0, x0, #1
	adr	x1, mas
	mov	x2, #0
L0:
	cmp	x2, x0
	bge	L3
	mov	x3, x2
	mov	x4, x2
	ldr	x6, [x1, x4, lsl #3]
L1:
	add	x3, x3, #1
	cmp	x3, x0
	bgt	L2
	ldr	x5, [x1, x3, lsl #3]
	cmp	x5, x6
	bge	L1
	mov	x4, x3
	mov	x6, x5
	b	L1
L2:
	ldr	x5, [x1, x2, lsl #3]
	str	x5, [x1, x4, lsl #3]
	str	x6, [x1, x2, lsl #3]
	add	x2, x2, #1
	b	L0
L3:
	mov	x0, #0
	mov	x8, #93
	svc	#0
	.size	_start, .-_start
