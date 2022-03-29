	.arch armv8-a
//	QuickSort
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
	adr	x0, mas
	mov	x1, #0
	adr	x2, n
	ldr	x2, [x2]
	sub	x2, x2, #1
	bl	quick
	mov	x0, #0
	mov	x8, #93
	svc	#0
	.size	_start, .-_start
	.type	quick, %function
	.equ	i, 16
	.equ	j, 24
quick:
	stp	x29, x30, [sp, #-32]!
	mov	x29, sp
	str	x1, [x29, i]
	str	x2, [x29, j]
	ldr	x3, [x0, x1, lsl #3]
0:
	cmp	x1, x2
	beq	4f
	ldr	x4, [x0, x2, lsl #3]
	cmp	x3, x4
	bgt	1f
	sub	x2, x2, #1
	b	0b
1:
	str	x4, [x0, x1, lsl #3]
	add	x1, x1, #1
2:
	cmp	x1, x2
	beq	4f
	ldr	x4, [x0, x1, lsl #3]
	cmp	x3, x4
	blt	3f
	add	x1, x1, #1
	b	2b
3:
	str	x4, [x0, x2, lsl #3]
	sub	x2, x2, #1
	b	0b
4:
	str	x3, [x0, x1, lsl #3]
	str	x1, [sp, #-16]!
	ldr	x1, [x29, i]
	sub	x2, x2, #1
	cmp	x1, x2
	bge	5f
	bl	quick
5:
	ldr	x1, [sp], #16
	add	x1, x1, #1
	ldr	x2, [x29, j]
	cmp	x1, x2
	bge	6f
	bl	quick
6:
	ldp	x29, x30, [sp], #32
	ret
	.size	quick, .-quick
