	.arch armv8-a
//	Revers symbols in words	
	.data
mes1:
	.ascii	"Enter string: "
	.equ	len, .-mes1
str:
	.skip	1024
mes2:
	.ascii	"Result: '"
newstr:
	.skip	1024
	.text
	.align	2
	.global _start	
	.type	_start, %function
_start:
	mov	x0, #1
	adr	x1, mes1
	mov	x2, len
	mov	x8, #64
	svc	#0
	mov	x0, #0
	adr	x1, str
	mov	x2, #1023
	mov	x8, #63
	svc	#0
	cmp	x0, #0
	ble	L6
	adr	x1, str
	sub	x0, x0, #1
	strb	wzr, [x1, x0]
	adr	x3, newstr
	mov	x4, x3
L0:
	ldrb	w0, [x1], #1
	cbz	w0, L5
	cmp	w0, ' '
	beq	L0
	cmp	x4, x3
	beq	L1
	mov	w0, ' '
	strb	w0, [x3], #1
L1:
	sub	x2, x1, #1
L2:
	ldrb	w0, [x1], #1
	cbz	w0, L3
	cmp	w0, ' '
	bne	L2
L3:
	sub	x5, x1, #1
L4:
	ldrb	w0, [x5, #-1]!
	strb	w0, [x3], #1
	cmp	x5, x2
	bgt	L4
	sub	x1, x1, #1
	b	L0
L5:
	mov	w0, '\''
	strb	w0, [x3], #1
	mov	w0, '\n'
	strb	w0, [x3], #1
	mov	x0, #1
	adr	x1, mes2
	sub	x2, x3, x1
	mov	x8, #64
	svc	#0
	b	_start
L6:
	mov	x0, #0
	mov	x8, #93
	svc	#0
	.size	_start, .-_start
