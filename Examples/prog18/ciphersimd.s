	.arch armv8-a
	.text
	.align	2
	.global cipher
	.type	cipher, %function
cipher:
	mov	w6, #64
	udiv	w4, w3, w6
	msub	w5, w4, w6, w3
	dup	v0.2d, x2
1:
	cbz	w4, 2f
	sub	w4, w4, #1
	ld4	{v1.2d - v4.2d}, [x0], #64
	eor	v1.16b, v1.16b, v0.16b
	eor	v2.16b, v2.16b, v0.16b
	eor	v3.16b, v3.16b, v0.16b
	eor	v4.16b, v4.16b, v0.16b
	st4	{v1.2d - v4.2d}, [x1], #64
	b	1b
2:
	cmp	w5, #48
	blt	3f
	ld3	{v1.2d - v3.2d}, [x0], #48
	eor	v1.16b, v1.16b, v0.16b
	eor	v2.16b, v2.16b, v0.16b
	eor	v3.16b, v3.16b, v0.16b
	st3	{v1.2d - v3.2d}, [x1], #48
	sub	w5, w5, #48
	b	4f
3:
	cmp	w5, #32
	blt	4f
	ld2	{v1.2d - v2.2d}, [x0], #32
	eor	v1.16b, v1.16b, v0.16b
	eor	v2.16b, v2.16b, v0.16b
	st2	{v1.2d - v2.2d}, [x1], #32
	sub	w5, w5, #32
4:
	cmp	w5, #16
	blt	5f
	ld1	{v1.2d}, [x0], #16
	eor	v1.16b, v1.16b, v0.16b
	st1	{v1.2d}, [x1], #16
	sub	w5, w5, #16
5:
	cbz	w5, 8f
	cmp	w5, #8
	blt	6f
	ld1	{v1.8b}, [x0], #8
	eor	v1.8b, v1.8b, v0.8b
	st1	{v1.8b}, [x1], #8
	sub	w5, w5, #8
	cbz	w5, 7f
6:
	cmp	w5, #4
	blt	7f
	ldr	w6, [x0], #4
	eor	w6, w6, w2
	str	w6, [x1], #4
	lsr	x2, x2, #32
	sub	w5, w5, #4
7:
	cbz	w5, 8f
	sub	w5, w5, #1
	ldrb	w6, [x0], #1
	eor	w6, w6, w2
	strb	w6, [x1], #1
	lsr	x2, x2, #8
	b	7b
8:
	ret
	.size	cipher, .-cipher
