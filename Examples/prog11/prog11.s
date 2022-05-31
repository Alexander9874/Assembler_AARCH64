	.arch armv8-a
//	Print text file
	.data
errmes1:
	.string	"Usage: "
	.equ	errlen1, .-errmes1
errmes2:
	.string	" filename\n"
	.equ	errlen2, .-errmes2
	.text
	.align	2
	.global _start	
	.type	_start, %function
_start:
	ldr	x0, [sp]
	cmp	x0, #2
	beq	2f
	mov	x0, #2
	adr	x1, errmes1
	mov	x2, errlen1
	mov	x8, #64
	svc	#0
	mov	x0, #2
	ldr	x1, [sp, #8]
	mov	x2, #0
0:
	ldrb	w3, [x1, x2]
	cbz	w3, 1f
	add	x2, x2, #1
	b	0b
1:
	mov	x8, #64
	svc	#0
	mov	x0, #2
	adr	x1, errmes2
	mov	x2, errlen2
	mov	x8, #64
	svc	#0
	mov	x0, #1
	b	3f
2:
	ldr	x0, [sp, #16]
	bl	work
3:
	mov	x8, #93
	svc	#0
	.size	_start, .-_start
	.type	work, %function
	.text
	.align	2
	.equ	filename, 16
	.equ	fd, 24
	.equ	buf, 32
work:
	mov	x16, #4128
	sub	sp, sp, x16
	stp	x29, x30, [sp]
	mov	x29, sp
	str	x0, [x29, filename]
	mov	x1, x0
	mov	x0, #-100
	mov	x2, #0
	mov	x8, #56
	svc	#0
	cmp	x0, #0
	bge	0f
	bl	writeerr
	b	4f
0:
	str	x0, [x29, fd]
1:
	ldr	x0, [x29, fd]
	add	x1, x29, buf
	mov	x2, #4096
	mov	x8, #63
	svc	#0
	cmp	x0, #0
	beq	3f
	bgt	2f
	str	x0, [sp, #-16]!
	ldr	x0, [x29, fd]
	mov	x8, #57
	svc	#0
	ldr	x0, [sp], #16
	bl	writeerr
	mov	x0, #1
	b	4f
2:
	mov	x2, x0
	mov	x0, #1
	add	x1, x29, buf
	mov	x8, #64
	svc	#0
	b	1b
3:
	ldr	x0, [x29, fd]
	mov	x8, #57
	svc	#0
	mov	x0, #0
4:
	ldp	x29, x30, [sp]
	mov	x16, #4128
	add	sp, sp, x16
	ret
	.size	work, .-work
	.type	writeerr, %function
	.data
nofile:
	.string	"No such file or directory\n"
	.equ	nofilelen, .-nofile
permission:
	.string	"Permission denied\n"
	.equ	permissionlen, .-permission
unknown:
	.string	"Unknown error\n"
	.equ	unknownlen, .-unknown
	.text
	.align	2
writeerr:
	cmp	x0, #-2
	bne	0f
	adr	x1, nofile
	mov	x2, nofilelen
	b	2f
0:
	cmp	x0, #-13
	bne	1f
	adr	x1, permission
	mov	x2, permissionlen
	b	2f
1:
	adr	x1, unknown
	mov	x2, unknownlen
2:
	mov	x0, #2
	mov	x8, #64
	svc	#0
	ret
	.size	writeerr, .-writeerr
