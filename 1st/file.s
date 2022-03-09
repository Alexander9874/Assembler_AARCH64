//
//	25 - 7
//
//	      a * c   d * b   c ^ 2
//	res = ----- + ----- - -----
//	        b       e     a * d
//		+c	+c
//
//	size of all variables is 16
//
//	vars are from -32767 to 32767
//
	.arch 	armv8-a
	.data
	.align	3
res:
	.skip	8
a:
	.short	1
b:
	.short	1
c:
	.short	8
d:
	.short	1
e:
	.short	1
	.text
	.align	2
	.global	_start
	.type	_start, %function
_start:
	adr	x0, a
	ldrsh	w0, [x0]		// w0 is a
	adr	x1, b
	ldrsh	w1, [x1]		// w1 is b
	adr	x2, c
	ldrsh	w2, [x2]		// w2 is c
	adr	x3, d
	ldrsh	w3, [x3]		// w3 is d
	adr	x4, e
	ldrsh	w4, [x4]		// w4 is e
	mul	w5, w0, w2		// w5 is a*c
	
	add	w10, w1, w2
	add	w11, w4, w2

//	sdiv	w5, w5, w1		// w5 is (a*c)/b
	
	sdiv	w5, w5, w10

	mul	w6, w3, w1		// w6 is d*b
//	sdiv	w6, w6, w4		// w5 is (d*b)/e

	sdiv	w6, w6, w11

	add	w5, w5, w6
	sxtw	x5, w5			// x5 is ((a*c)/b)+((d*b)/e)
	mul	w6, w2, w2		// w6 is c*c
	sdiv	w6, w6, w0		// w6 is c*c/a
	sdiv	w6, w6, w3		// w6 is (c*c)/(a*d)
	sub	x5, x5, x6		// res
	adr	x0, res
	str	x5, [x0]
	mov	x0, #0
	mov	x5, #93
	svc	#0
	.size	_start, .-_start
