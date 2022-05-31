	.arch armv8-a
	.text
	.align	2
	.global cipher
	.type	cipher, %function
cipher:
	mov	w6, #8
	udiv	w4, w3, w6
	msub	w5, w4, w6, w3
1:
	cbz	w4, 2f
	sub	w4, w4, #1
	ldr	x6, [x0], #8
	eor	x6, x6, x2
	str	x6, [x1], #8
	b	1b
	cmp	w5, #4
	blt	2f
	ldr	w6, [x0], #4
	eor	w6, w6, w2
	str	w6, [x1], #4
	lsr	x2, x2, #32
	sub	w5, w5, #4
2:
	cbz	w5, 3f
	sub	w5, w5, #1
	ldrb	w6, [x0], #1
	eor	w6, w6, w2
	strb	w6, [x1], #1
	lsr	x2, x2, #8
	b	2b
3:
	ret
	.size	cipher, .-cipher
