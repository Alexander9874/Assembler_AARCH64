	.arch armv8-a
//	res=(a+b)*d*e/c-(c+d)/a
	.data
	.align	3
res:
	.skip	8
a:
	.short	40
b:
	.short	100
c:
	.short	20
d:
	.short	20
e:
	.short	30
	.text
	.align	2
	.global _start
	.type	_start, %function
_start:
	adr	x0, a
	ldrsh	w1, [x0]		// w1 is a
	adr	x0, b			
	ldrsh	w2, [x0]		// w2 is b
	adr	x0, c
	ldrsh	x3, [x0]		// w3 is c
	adr	x0, d
	ldrsh	w4, [x0]		// w4 is d
	adr	x0, e
	ldrsh	w5, [x0]		// w5 is e
	add	w6, w1, w2		// w6 is a+b
	mul	w7, w4, w5		// w7 is d*e
	smull	x8, w6, w7		// x8 is (a+b)*(d*e)
	sdiv	x8, x8, x3		// x8 is ((a+b)*d*e)/c
	add	w6, w3, w4		// w6 is c+d
	sdiv	w6, w6, w1		// w6 is (c+d)/a
	sub	x8, x8, w6, sxtw	// x8 is ((a+b)*d*e/c)-((c+d)/a)
	adr	x0, res			
	str	x8, [x0]
	mov	x0, #0
	mov	x8, #93
	svc	#0
	.size	_start, .-_start
