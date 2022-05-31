	.arch armv8-a
//	Search max
	.data
	.align	3
n:
	.quad	10
mas:
	.quad	8, 7, 1, 9, 5, 2, 6, 0, 4, 3
max:
	.skip	8
	.text
	.align	2
	.global _start
	.type	_start, %function
_start:
	adr	x0, max
	adr	x1, n
	ldr	x1, [x1]
	adr	x2, mas
	mov	x3, #0
	ldr	x4, [x2]
L0:
	add	x3, x3, #1
	cmp	x3, x1
	bge	L1
	ldr	x5, [x2, x3, lsl #3]
	cmp	x5, x4
	csel	x4, x5, x4, gt
//	ble	L0
//	mov	x4, x5
	b	L0
L1:
	str	x4, [x0]
	mov	x0, #0
	mov	x8, #93
	svc	#0
	.size	_start, .-_start
