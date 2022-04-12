	.arch armv8-a
//	Lexicographic word sorting in string
	.data
mes1:
	.ascii	"Enter string: "
	.equ	len1, .-mes1
mes2:
	.ascii	"Result: "
	.equ	len2, .-mes2
delim:
	.string	" \t"
str:
	.skip	1024
newstr:
	.skip	1024
	.text
	.align	2
	.global _start	
	.type	_start, %function
_start:
	mov	x0, #1
	adr	x1, mes1
	mov	x2, len1
	mov	x8, #64
	svc	#0
	mov	x0, #0
	adr	x1, str
	mov	x2, #1023
	mov	x8, #63
	svc	#0
	cmp	x0, #0
	ble	1f
	adr	x1, str
	add	x0, x0, x1
	ldrb	w1, [x0, #-1]
	cmp	w1, '\n'
	bne	0f
	sub	x0, x0, #1
0:
	strb	wzr, [x0]
	adr	x0, str
	adr	x1, newstr
	adr	x2, delim
	bl	work
	adr	x1, newstr
	mov	w2, '\n'
	strb	w2, [x1, x0]
	add	x19, x0, #1
	mov	x0, #1
	adr	x1, mes2
	mov	x2, len2
	mov	x8, #64
	svc	#0
	mov	x0, #1
	adr	x1, newstr
	mov	x2, x19
	mov	x8, #64
	svc	#0
	b	_start
1:
	mov	x0, #0
	mov	x8, #93
	svc	#0
	.size	_start, .-_start
	.type	work, %function
	.equ	from, 16
	.equ	to, 24
	.equ	del, 32
	.equ	n, 40
	.equ	wpoint, 48
	.equ	wlength, 4144
work:
	mov	x16, #5168
	sub	sp, sp, x16
	stp	x29, x30, [sp]
	mov	x29, sp
	str	x0, [x29, from]
	str	x1, [x29, to]
	str	x2, [x29, del]
	mov	x1, #0
	add	x3, x29, wpoint
	mov	x16, wlength
	add	x4, x29, x16
	mov	x8, #0
0:
	ldrb	w5, [x0], #1
	cbz	w5, 3f
	mov	x6, x2
1:
	ldrb	w7, [x6], #1
	cbz	w7, 2f
	cmp	w5, w7
	beq	3f
	b	1b
2:
	cbnz	x8, 0b
	sub	x8, x0, #1
	str	x8, [x3, x1, lsl #3]
	b	0b
3:
	cbz	x8, 4f
	sub	x8, x0, x8
	sub	x8, x8, #1
	strh	w8, [x4, x1, lsl #1]
	add	x1, x1, #1
	mov	x8, #0
4:
	cbnz	w5, 0b
	str	x1, [x29, n]
	mov	x0, x1
	add	x1, x29, wpoint
	add	x2, x29, x16
	bl	sort
	mov	x0, #0
	ldr	x1, [x29, n]
	ldr	x2, [x29, to]
	add	x3, x29, wpoint
	mov	x16, wlength
	add	x4, x29, x16
	mov	x7, #0
5:
	cmp	x0, x1
	beq	8f
	cbz	x0, 6f
	mov	w5, ' '
	strb	w5, [x2], #1
6:
	ldr	x6, [x3, x0, lsl #3]
	ldrh	w7, [x4, x0, lsl #1]
7:
	ldrb	w5, [x6], #1
	strb	w5, [x2], #1
	sub	w7, w7, #1
	cbnz	w7, 7b
	add	x0, x0, #1
	b	5b
8:
	strb	wzr, [x2]
	ldr	x0, [x29, to]
	sub	x0, x2, x0
	ldp	x29, x30, [sp]
	mov	x16, #5168
	add	sp, sp, x16
	ret
	.size	work, .-work
	.type	sort, %function
	.equ	n, 16
	.equ	pwpoint, 24
	.equ	pwlength, 32
sort:
	stp	x29, x30, [sp, #-48]!
	mov	x29, sp
	sub	x0, x0, 1
	str	x0, [x29, n]
	str	x1, [x29, pwpoint]
	str	x2, [x29, pwlength]
	mov	x3, #0
0:
	cmp	x3, x0
	bge	3f
	mov	x4, x3
	mov	x5, x3
	ldr	x7, [x1, x5, lsl #3]
	ldrh	w9, [x2, x5, lsl #1]
1:
	add	x4, x4, #1
	cmp	x4, x0
	bgt	2f
	ldr	x6, [x1, x4, lsl #3]
	ldrh	w8, [x2, x4, lsl #1]
	sub	sp, sp, #64
	stp	x3, x4, [sp]
	stp	x5, x6, [sp, #16]
	stp	x7, x8, [sp, #32]
	str	x9, [sp, #48]
	mov	x0, x6
	mov	x1, x7
	mov	w2, w8
	mov	w3, w9
	bl	compare
	mov	w10, w0
	ldr	x0, [x29, n]
	ldr	x1, [x29, pwpoint]
	ldr	x2, [x29, pwlength]
	ldp	x3, x4, [sp]
	ldp	x5, x6, [sp, #16]
	ldp	x7, x8, [sp, #32]
	ldr	x9, [sp, #48]
	add	sp, sp, #64
	cmp	w10, #0
	bge	1b
	mov	x5, x4
	mov	x7, x6
	mov	w9, w8
	b	1b
2:
	ldr	x6, [x1, x3, lsl #3]
	str	x6, [x1, x5, lsl #3]
	str	x7, [x1, x3, lsl #3]
	ldrh	w8, [x2, x3, lsl #1]
	strh	w8, [x2, x5, lsl #1]
	strh	w9, [x2, x3, lsl #1]
	add	x3, x3, #1
	b	0b
3:
	ldp	x29, x30, [sp], #48
	ret
	.size	sort, .-sort
	.type	compare, %function
compare:
	cbz	w2, 0f
	cbz	w3, 0f
	sub	w2, w2, #1
	sub	w3, w3, #1
	ldrb	w5, [x0], #1
	ldrb	w6, [x1], #1
	cmp	w5, w6
	beq	compare
	sub	w0, w5, w6
	ret
0:
	sub	w0, w2, w3
	ret
	.size	compare, .-compare
