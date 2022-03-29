	.arch armv8-a
//	InsertionSort
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
	mov	x2, #0
L0:
	add	x2, x2, #1
	cmp	x2, x0
	bge	L3
	ldr	x5, [x1, x2, lsl #3]
	mov	x3, x2
L1:
	mov	x4, x3
	cbz	x3, L2
	sub	x3, x3, #1
	ldr	x6, [x1, x3, lsl #3]
	cmp	x5, x6
	bge	L2
	str	x6, [x1, x4, lsl #3]
	b	L1
L2:
	str	x5, [x1, x4, lsl #3]
	b	L0
L3:
	mov	x0, #0
	mov	x8, #93
	svc	#0
	.size	_start, .-_start
