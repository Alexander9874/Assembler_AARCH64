	.arch	armv8-a
	.data
	.align	3
matrix:
	.quad	0,  12, -23, -43, -9
	.quad	1,  32,   0,  34, -8
	.quad	2,  -9,   1,  56, -7
	.quad	3,  45,   9,  67, -6
	.quad	4,  23,  -3,  -6, -5
	.quad	5, -55,  89,  41, -4
	.quad	6, -99,  -8, -41, -3
	.quad	7,  45,  -1, -40, -2
	.quad	8,  23,  45,  55, -1
	.quad	9,  91,  34,  99,  0
width:
	.quad	5
height:
	.quad	10
	.text
	.align	2

	.global	_start
	.type	_start, %function
_start:
	adr	x0, matrix
	adr	x1, width
	adr	x2, height
	ldr	x1, [x1]
	ldr	x2, [x2]
	mov	x3, #0			// x3 is index of column (i_c)
L0:
	cmp	x3, x1
	beq	L1
	bl	cocktail
	add	x3, x3, #1
	b	L0
L1:
	mov	x0, #0
	mov	x8, #93
	svc	#0
	.size	_start, .-_start

	.type	cocktail, %function
cocktail:
	stp	x29, x30, [sp, #-32]!
	mov	x4, 0			// x4 is left
	sub	x5, x2, #1		// x5 is right
	mov	x6, x5			// x6 is control
C0:
	sub	x7, x4, #1		// x7 is index
C1:
	add	x7, x7, #1		// index++
	cmp	x7, x5			// index < right
	bge	C2			// FALSE
	bl	sort_1
	b	C1
C2:
	mov	x5, x6			// right = control
	add	x7, x5, #1		// x7 is index
C3:
	sub	x7, x7, #1		// index--
	cmp	x7, x4
	ble	C4
	bl	sort_2
	b	C3
C4:
	mov	x4, x6
	cmp	x4, x5
	blt	C0
	ldp	x29, x30, [sp], #32
	ret
	.size	cocktail, .-cocktail

	.type	sort_1, %function
sort_1:
	stp	x29, x30, [sp, #-32]!
	mul	x10, x7, x1		// offset without column index
	add	x10, x10, x3		// offset
	ldr	x8, [x0, x10, lsl #3]	// x8 is matrix[i][i_c]
	add	x10, x10, x1
	ldr	x9, [x0, x10, lsl #3]	// x9 is matrix[i+1][i_c]
	cmp	x8, x9			// matrix[i][i_c] < matrix[i+1][i_c]
	bge	C1
	str	x8, [x0, x10, lsl #3]
	sub	x10, x10, x1
	str	x9, [x0, x10, lsl #3]
	mov	x6, x7
	ldp	x29, x30, [sp], #32
	ret
	.size	sort_1, .-sort_1

	.type	sort_2, %function
sort_2:
	stp	x29, x30, [sp, #-32]!
	mul	x10, x7, x1		// offset without column index
	add	x10, x10, x3		// offset
	ldr	x9, [x0, x10, lsl #3]	// x9 is matrix[i][i_c]
	sub	x10, x10, x1
	ldr	x8, [x0, x10, lsl #3]	// x8 is matrix[i-1][i_c]
	cmp	x8, x9			// matrix[i-1][i_c] < matrix[i][i_c]
	bge	C3
	str	x9, [x0, x10, lsl #3]
	add	x10, x10, x1
	str	x8, [x0, x10, lsl #3]
	mov	x6, x7
	ldp	x29, x30, [sp], #32
	ret
	.size	sort_2, .-sort_2
