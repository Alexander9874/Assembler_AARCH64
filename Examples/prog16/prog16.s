	.arch armv8-a
//	Integral of the exponent by the Simpson method	
	.data
mes1:
	.string	"Input x1\n"
mes2:
	.string	"Input x2\n"
mes3:
	.string	"Input n\n"
mes4:
	.string	"x1 greater than x2\n"
mes5:
	.string	"n should be from 1 to 100\n"
form1:
	.string	"%lf"
form2:
	.string	"%d"
form3:
	.string	"Exact integral equal %f\n"
form4:
	.string	"My integral equal %f\n"
	.text
	.align	2
	.global	main
	.type	main, %function
	.equ	scanbuf, 64
main:
	sub	sp, sp, #-80
	stp	x29, x30, [sp]
	str	x28, [sp, #16]
	stp	d8, d9, [sp, #32]
	stp	d10, d11, [sp, #48]
	mov	x29, sp
	adr	x0, mes1
	bl	printf
	adr	x0, form1
	add	x1, x29, scanbuf
	bl	scanf
	ldr	d8, [x29, scanbuf]
	adr	x0, mes2
	bl	printf
	adr	x0, form1
	add	x1, x29, scanbuf
	bl	scanf
	ldr	d9, [x29, scanbuf]
	adr	x0, mes3
	bl	printf
	adr	x0, form2
	add	x1, x29, scanbuf
	bl	scanf
	ldr	w28, [x29, scanbuf]
	fcmp	d8, d9
	ble	0f
	adr	x0, mes4
	bl	printf
	b	6f
0:
	cmp	w28, #1
	blt	1f
	mov	w0, #100
	cmp	w28, w0
	ble	2f
1:
	adr	x0, mes5
	bl	printf
	b	6f
2:
	fmov	d0, d8
	bl	exp
	fmov	d10, d0
	fmov	d0, d9
	bl	exp
	fsub	d0, d0, d10
	adr	x0, form3
	bl	printf
	lsl	w28, w28, #1
	ucvtf	d10, w28
	fsub	d9, d9, d8
	fdiv	d9, d9, d10
	fmov	d0, d8
	fadd	d8, d8, d9
	bl	exp
	fmov	d10, d0
	fmov	d11, #2.0
3:
	sub	w28, w28, #1
	cbz	w28, 5f
	fmov	d0, d8
	fadd	d8, d8, d9
	bl	exp
	tbz	w28, #0, 4f
	fmul	d0, d0, d11
4:
	fmadd	d10, d0, d11, d10
	b	3b
5:
	fmov	d0, d8
	bl	exp
	fadd	d10, d10, d0
	fmul	d10, d10, d9
	fmov	d0, #3.0
	fdiv	d0, d10, d0
	adr	x0, form4
	bl	printf
6:
	mov	w0, 0
	ldp	x29, x30, [sp]
	ldr	x28, [sp, #16]
	ldp	d8, d9, [sp, #32]
	ldp	d10, d11, [sp, #48]
	add	sp, sp, #80
	ret
	.size	main, .-main
