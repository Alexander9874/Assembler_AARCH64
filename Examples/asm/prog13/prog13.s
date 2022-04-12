	.arch armv8-a
//	Copy all odd words in each string from file1 to file2
	.data
mes1:
	.string	"Input filename for read\n"
	.equ	mes1len, .-mes1
mes2:
	.string	"Input filename for write\n"
	.equ	mes2len, .-mes2
mes3:
	.string	"File exists. Rewrite(Y/N)?\n"
	.equ	mes3len, .-mes3
ans:
	.skip	3
name1:
	.skip	1024
name2:
	.skip	1024
	.align	3
fd1:
	.skip	8
fd2:
	.skip	8
	.text
	.align	2
	.global _start	
	.type	_start, %function
_start:
	ldr	x0, [sp]
	cmp	x0, #1
	beq	0f
	mov	x0, #0
	b	8f
0:
	mov	x0, #1
	adr	x1, mes1
	mov	x2, mes1len
	mov	x8, #64
	svc	#0
	mov	x0, #0
	adr	x1, name1
	mov	x2, #1024
	mov	x8, #63
	svc	#0
	cmp	x0, #1
	ble	1f
	cmp	x0, #1024
	blt	2f
1:
	mov	x0, #1
	b	8f
2:
	sub	x2, x0, #1
	mov	x0, #-100
	adr	x1, name1
	strb	wzr, [x1, x2]
	mov	x2, #0
	mov	x8, #56
	svc	#0
	cmp	x0, #0
	blt	8f
	adr	x1, fd1
	str	x0, [x1]
	mov	x0, #1
	adr	x1, mes2
	mov	x2, mes2len
	mov	x8, #64
	svc	#0
	mov	x0, #0
	adr	x1, name2
	mov	x2, #1024
	mov	x8, #63
	svc	#0
	cmp	x0, #1
	ble	3f
	cmp	x0, #1024
	bl	4f
3:
	mov	x0, #1
	b	9f
4:
	sub	x2, x0, #1
	mov	x0, #-100
	adr	x1, name2
	strb	wzr, [x1, x2]
	mov	x2, #0xc1
	mov	x3, #0600
	mov	x8, #56
	svc	#0
	cmp	x0, #0
	bge	7f
	cmp	x0, #-17
	bne	9f
	mov	x0, #1
	adr	x1, mes3
	mov	x2, mes3len
	mov	x8, #64
	svc	#0
	mov	x0, #0
	adr	x1, ans
	mov	x2, #3
	mov	x8, #63
	svc	#0
	cmp	x0, #2
	beq	5f
	mov	x0, #-17
	b	9f
5:
	adr	x1, ans
	ldrb	w0, [x1]
	cmp	w0, 'Y'
	beq	6f
	cmp	w0, 'y'
	beq	6f
	mov	x0, #-17
	b	9f
6:
	mov	x0, #-100
	adr	x1, name2
	mov	x2, #0x201
	mov	x8, #56
	svc	#0
	cmp	x0, #0
	blt	9f
7:
	adr	x1, fd2
	str	x0, [x1]
	adr	x0, fd1
	ldr	x0, [x0]
	adr	x1, fd2
	ldr	x1, [x1]
	bl	work
	cbnz	x0, 0f
	adr	x0, fd1
	ldr	x0, [x0]
	mov	x8, #57
	svc	#0
	adr	x0, fd2
	ldr	x0, [x0]
	mov	x8, #57
	svc	#0
	mov	x0, #0
	b	1f
8:
	bl	writeerr
	mov	x0, #1
	b	1f
9:
	bl	writeerr
	adr	x0, fd1
	ldr	x0, [x0]
	mov	x8, #57
	svc	#0
	mov	x0, #1
	b	1f
0:
	bl	writeerr
	adr	x0, fd1
	ldr	x0, [x0]
	mov	x8, #57
	svc	#0
	adr	x0, fd2
	ldr	x0, [x0]
	mov	x8, #57
	svc	#0
	mov	x0, #1
1:
	mov	x8, #93
	svc	#0
	.size	_start, .-_start
	.type	work, %function
	.equ	f1, 16
	.equ	f2, 24
	.equ	tmp, 32
	.equ	flg, 40
	.equ	wrd, 44
	.equ	bufin, 48
	.equ	bufout, 4144
	.text
	.align	2
work:
	mov	x16, #8240
	sub	sp, sp, x16
	stp	x29, x30, [sp]
	mov	x29, sp
	str	x0, [x29, f1]
	str	x1, [x29, f2]
	str	xzr, [x29, flg]
0:
	ldr	x0, [x29, f1]
	add	x1, x29, bufin
	mov	x2, #4096
	mov	x8, #63
	svc	#0
	cmp	x0, #0
	blt	8f
	beq	9f
	add	x0, x0, x29
	add	x0, x0, bufin
	ldr	w1, [x29, flg]
	add	x3, x29, bufin
	mov	x16, bufout
	add	x4, x29, x16
	ldr	w5, [x29, wrd]
	mov	w6, ' '
1:
	cmp	x3, x0
	bge	6f
	ldrb	w2, [x3], #1
	cbz	w2, 2f
	cmp	w2, '\n'
	beq	2f
	cmp	w2, ' '
	beq	3f
	cmp	w2, '\t'
	beq	3f
	cbz	w1, 4f
	tbz	w5, #0, 1b
	b	5f
2:
	mov	w1, #0
	mov	w5, #0
	b	5f
3:
	mov	w1, #0
	b	1b
4:
	add	w5, w5, #1
	mov	w1, #1
	tbz	w5, #0, 1b
	cmp	w5, #1
	beq	5f
	strb	w6, [x4], #1
5:
	strb	w2, [x4], #1
	b	1b
6:
	str	w1, [x29, flg]
	str	w5, [x29, wrd]
	mov	x16, bufout
	add	x1, x29, x16
	sub	x2, x4, x1
	cbz	x2, 0b
	str	x2, [x29, tmp]
7:
	ldr	x0, [x29, f2]
	mov	x8, #64
	svc	#0
	cmp	x0, #0
	blt	8f
	ldr	x2, [x29, tmp]
	cmp	x0, x2
	beq	0b
	mov	x16, bufout
	add	x1, x29, x16
	add	x1, x1, x0
	sub	x2, x2, x0
	str	x2, [x29, tmp]
	b	7b
8:
	str	x0, [x29, tmp]
	ldr	x0, [x29, f2]
	mov	x1, #0
	mov	x8, #46
	svc	#0
	ldr	x0, [x29, tmp]
9:
	ldp	x29, x30, [sp]
	mov	x16, #8240
	add	sp, sp, x16
	ret
	.size	work, .-work
	.type	writeerr, %function
	.data
usage:
	.string	"Program does not require parameters\n"
	.equ	usagelen, .-usage
nofile:
	.string	"No such file or directory\n"
	.equ	nofilelen, .-nofile
permission:
	.string	"Permission denied\n"
	.equ	permissionlen, .-permission
exist:
	.string	"File exists\n"
	.equ	existlen, .-exist
isdir:
	.string	"Is a directory\n"
	.equ	isdirlen, .-isdir
toolong:
	.string	"File name too long\n"
	.equ	toolonglen, .-toolong
readerror:
	.string "Error readig filename\n"
	.equ	readerrorlen, .-readerror
unknown:
	.string	"Unknown error\n"
	.equ	unknownlen, .-unknown
	.text
	.align	2
writeerr:
	cbnz	x0, 0f
	adr	x1, usage
	mov	x2, usagelen
	b	7f
0:
	cmp	x0, #-2
	bne	1f
	adr	x1, nofile
	mov	x2, nofilelen
	b	7f
1:
	cmp	x0, #-13
	bne	2f
	adr	x1, permission
	mov	x2, permissionlen
	b	7f
2:
	cmp	x0, #-17
	bne	3f
	adr	x1, exist
	mov	x2, existlen
	b	7f
3:
	cmp	x0, #-21
	bne	4f
	adr	x1, isdir
	mov	x2, isdirlen
	b	7f
4:
	cmp	x0, #-36
	bne	5f
	adr	x1, toolong
	mov	x2, toolonglen
	b	7f
5:
	cmp	x0, #1
	bne	6f
	adr	x1, readerror
	mov	x2, readerrorlen
	b	7f
6:
	adr	x1, unknown
	mov	x2, unknownlen
7:
	mov	x0, #2
	mov	x8, #64
	svc	#0
	ret
	.size	writeerr, .-writeerr
