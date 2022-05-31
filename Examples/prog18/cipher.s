	.arch armv8-a
	.file	"cipher.c"
	.text
	.align	2
	.p2align 3,,7
	.global	cipher
	.type	cipher, %function
cipher:
	cmp	w3, 0
	add	w4, w3, 7
	csel	w4, w4, w3, lt
	negs	w6, w3
	and	w6, w6, 7
	and	w3, w3, 7
	asr	w4, w4, 3
	csneg	w6, w3, w6, mi
	cmp	w4, 0
	ble	.L2
	add	x5, x0, 16
	add	x3, x1, 16
	cmp	x5, x1
	ccmp	x0, x3, 2, hi
	ccmp	w4, 6, 0, cs
	bls	.L10
	ubfx	w3, w0, 3, 1
	mov	w11, 0
	cbz	w3, .L4
	ldr	x5, [x0]
	mov	w11, 1
	eor	x5, x5, x2
	str	x5, [x1]
.L4:
	uxtw	x7, w3
	sub	w8, w4, w3
	dup	v1.2d, x2
	mov	x3, 0
	lsl	x7, x7, 3
	lsr	w10, w8, 1
	add	x9, x0, x7
	add	x7, x1, x7
	mov	w5, 0
	.p2align 3
.L5:
	ldr	q0, [x9, x3]
	add	w5, w5, 1
	cmp	w5, w10
	eor	v0.16b, v1.16b, v0.16b
	str	q0, [x7, x3]
	add	x3, x3, 16
	bcc	.L5
	and	w3, w8, -2
	add	w11, w3, w11
	cmp	w8, w3
	beq	.L2
	sxtw	x5, w11
	add	w11, w11, 1
	cmp	w11, w4
	lsl	x3, x5, 3
	ldr	x7, [x0, x5, lsl 3]
	eor	x7, x7, x2
	str	x7, [x1, x5, lsl 3]
	bge	.L2
	add	x3, x3, 8
	ldr	x5, [x0, x3]
	eor	x5, x5, x2
	str	x5, [x1, x3]
.L2:
	cmp	w6, 0
	ble	.L16
.L20:
	stp	x29, x30, [sp, -64]!
	lsl	w4, w4, 3
	sub	w6, w6, #1
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	sxtw	x19, w4
	stp	x21, x22, [sp, 32]
	mov	x20, x1
	add	x21, x6, 1
	mov	x1, x0
	add	x1, x1, x19
	mov	x22, x2
	add	x0, x29, 48
	mov	x2, x21
	bl	memcpy
	add	x1, x29, 64
	ldr	x3, [x29, 48]
	mov	x2, x21
	add	x0, x20, x19
	eor	x22, x3, x22
	str	x22, [x1, -8]!
	bl	memcpy
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
	.p2align 2
.L10:
	mov	x3, 0
	.p2align 3
.L3:
	ldr	x5, [x0, x3, lsl 3]
	eor	x5, x5, x2
	str	x5, [x1, x3, lsl 3]
	add	x3, x3, 1
	cmp	w4, w3
	bgt	.L3
	cmp	w6, 0
	bgt	.L20
.L16:
	ret
	.size	cipher, .-cipher
	.ident	"GCC: (Linaro GCC 7.5-2019.12) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
