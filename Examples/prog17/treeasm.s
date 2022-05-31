	.arch armv8-a
	.text
	.align	2
	.global	Searchasm
	.type	Searchasm, %function
Searchasm:
	cbz	x0, 1f
	ldr	w2, [x0]
	cmp	w1, w2
	beq	1f
	bgt	0f
	ldr	x0, [x0, #8]
	b	Searchasm
0:
	ldr	x0, [x0, #16]
	b	Searchasm
1:
	ret
	.size	Searchasm, .-Searchasm
	.global	Addasm
	.type	Addasm, %function
Addasm:
	stp	x29, x30, [sp, #-16]!
	stp	x27, x28, [sp, #-16]!
	cbz	x0, 3f
	mov	x28, x0
	ldr	x0, [x0]
0:
	cbz	x0, 2f
	ldr	w2, [x0]
	cmp	w1, w2
	beq	3f
	bgt	1f
	add	x28, x0, #8
	ldr	x0, [x0, #8]
	b	0b
1:
	add	x28, x0, #16
	ldr	x0, [x0, #16]
	b	0b
2:
	mov	w27, w1
	mov	w0, #24
	bl	malloc
	cbz	x0, 4f
	str	x0, [x28]
	str	w27, [x0]
	str	xzr, [x0, #8]
	str	xzr, [x0, #16]
	mov	w0, #1
	b	4f
3:
	mov	w0, #0
4:
	ldp	x27, x28, [sp], #16
	ldp	x29, x30, [sp], #16
	ret
	.size	Addasm, .-Addasm
	.global	Delasm
	.type	Delasm, %function
Delasm:
	stp	x29, x30, [sp, #-16]!
	cbz	x0, 8f
	mov	x3, x0
	ldr	x0, [x0]
0:
	cbz	x0, 8f
	ldr	w2, [x0]
	cmp	w1, w2
	beq	2f
	bgt	1f
	add	x3, x0, #8
	ldr	x0, [x0, #8]
	b	0b
1:
	add	x3, x0, #16
	ldr	x0, [x0, #16]
	b	0b
2:
	ldr	x2, [x0, #16]
	cbnz	x2, 3f
	ldr	x2, [x0, #8]
	str	x2, [x3]
	b	7f
3:
	ldr	x2, [x0, #8]
	cbnz	x2, 4f
	ldr	x2, [x0, #16]
	str	x2, [x3]
	b	7f
4:
	mov	x1, x0
	add	x3, x0, #8
	mov	x0, x2
5:
	ldr	x2, [x0, #16]
	cbz	x2, 6f
	add	x3, x0, #16
	mov	x0, x2
	b	5b
6:
	ldr	w2, [x0]
	str	w2, [x1]
	ldr	x2, [x0, #8]
	str	x2, [x3]
7:
	bl	free
	mov	w0, 1
8:
	ldp	x29, x30, [sp], #16
	ret
	.size	Delasm, .-Delasm
