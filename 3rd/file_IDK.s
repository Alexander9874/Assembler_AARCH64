/*
 *	Remove from each word of the string the characters in even places.
 *	Data input - standard input ("from the keyboard").
 *	The output is a file.
 *	The way to pass parameters is through dialog interaction with the user.
 */
	.arch	armv8-a
	.data
	.align 3
msg_input:
	.string	"Input filename for write\n"
	.equ	len_input, .-msg
msg_rewrite:
	.string	"File exists. Rewrite(y/n)?\n"
	.equ	len_rewrite, .-msg_rewrite
answer:
	.skip	3
file_name:
	.skip	1024
file_descriptor:
	.skip	8
	.text
	.align	2
	.global	_start
	.type	_start, %function
_start:
	ldr	x0, [sp]
	cmp	x0, #1
	beq	0f
	mov	x0, #0			// x0 is erorr msg
	b	6f			// chech param
0:
	mov	x0, #1
	adr	x1, msg_input
	mov	x2, len_input
	mov	x8, #64
	svc	#0			// print msg_input
	mov	x0, #0
	adr	x1, file_name
	mov	x2, #1024
	mov	x8, #63
	svc	#0			// read 1024b to file_name
	cmp	x0, #1
	ble	1f
	cmp	x0, #1024
	blt	2f
1:
	mov	x0, #1
	b	6f
2:
	sub	x2, x0, x1		// x2 is len without \n
	mov	x0, #-100
	adr	x1, file_name
	strb	wzr, [x1, x2]		// \n -> \0
	mov	x2, #0xc1		///
	mov	x3, #0600		/// flag and permission
	mov	x8, #56
	svc	#0			// try to create file for write
	cmp	x0, #0
	bge	5f			// OK
	cmp	x0, #-17
	bne	6f			// NOT OK
	mov	x0, #1
	adr	x1, msg_rewrite
	mov	x2, len_rewrite
	mov	x8, #64
	svc	#0			// print msg_rewrite
	mov	x0, #0
	adr	x1, answer
	mov	x2, #3
	mov	x8, #63
	svc	#0			// read answer
	cmp	x0, #2
	beq	3f
	mov	x0, #-17
	b	6f
3:
	adr	x1, answer
	ldrb	w0, [x1]
	cmp	w0, 'y'
	beq	4f
	mov	x0, #-17
	b	6f
4:
	mov	x0, #-100
	adr	x1, file_name
	mov	x2, #0x201
	mov	x8, #56
	svc	#0			// open empty file for write
	cmp	x0, #0
	blt	6f
5:
	adr	x1, file_descriptor
	str	x0, [x1]		// save file descriptor
	bl	work
	mov	x9, x0
	adr	x0, file_descriptor
	ldr	x0, [x0]
	mov	x8, #57
	svc	#0			// close file
	cdnz	x9, 6f
	mov	x0, #0
	b	7f
6:
	bl	write_error
	mov	x0, #1
7:
	mov	x8, #93
	svc	#0
	.size	_start, .-_start



	.type	work, %function
	.equ	fd, 16			// first 16 to save x29 & x30
	.equ	tmp, 24
	.equ	flag, 32		// is inside of the word
	.equ	even, 40		// is even
	.equ	first, 48
	.equ	input, 56
	.equ	output, 120
	.text
	.align	2
work:
	mov	x16, #184		// stack frame
	sub	sp, sp, x16
	stp	x29, x30, [sp]
	mov	x29, sp
	str	x0, [x29, fd]
	str	xzr, [x29, flag]
	str	xzr, [x29, even]
	mov	x16, #1
	str	x16, [x29, first]
0:
	mov	x0, #1
	add	x1, x29, input
	mov	x2, #64
	mov	x8, #63
	svc	#0			// read 64 bytes

	cmp	x0, #0
	beq	8f		//	!!!
	blt	9f		//	!!!

	add	x0, x0, x29
	add	x0, x0, input		// end of usefull information
	ldr	x1, [x29, flag]
	add	x3, x29, input
	mov	x16, outpu
	add	x4, x29, x16
	ldr	x5, [x29, even]
	mov	w6, ' '
	ldr	x7, [x29, first]
1:
	cmp	x3, x0			// is end of input?
	bge	6f		// !!!!

	ldrb	w2, [x3], #1		// w2 is input[i++]

	cbz	w2, 2f
	cmp	w2, '\n'
	beq	2f

	cmp	w2, ' '
	beq	3f
	cmp	w2, '\t'
	beq	3f

	cbz	x1, 4f			// is end of word of string; if start of word
	cbz	x5, 5f
2:
	mov	x1, #0
	mov	x5, #0
	mov	x7, #1
	b	5f
3:
	mov	x1, #0
	mov	x5, #0
	b	1b
4:
	mov	x1, #1
	cmp	x7, #1
	beq	FF
	strb	w6, [x4], #1
FF:
	mov	x7, #0
5:
	strb	w2, [x4], #1
	b	1b












.type   write_error, %function
        .data
usage:
        .string "Program does not require parameters\n"
        .equ    usagelen, .-usage
nofile:
        .string "No such file or directory\n"
        .equ    nofilelen, .-nofile
permission:
        .string "Permission denied\n"
        .equ    permissionlen, .-permission
exist:
        .string "File exists\n"
        .equ    existlen, .-exist
isdir:
        .string "Is a directory\n"
        .equ    isdirlen, .-isdir
toolong:
        .string "File name too long\n"
        .equ    toolonglen, .-toolong
readerror:
        .string "Error readig filename\n"
        .equ    readerrorlen, .-readerror
unknown:
        .string "Unknown error\n"
        .equ    unknownlen, .-unknown
        .text
        .align  2
writeerr:
        cbnz    x0, 0f
        adr     x1, usage
        mov     x2, usagelen
        b       7f
0:
        cmp     x0, #-2
        bne     1f
        adr     x1, nofile
        mov     x2, nofilelen
        b       7f
1:
        cmp     x0, #-13
        bne     2f
        adr     x1, permission
        mov     x2, permissionlen
        b       7f
2:
        cmp     x0, #-17
        bne     3f
        adr     x1, exist
        mov     x2, existlen
        b       7f
3:
        cmp     x0, #-21
        bne     4f
        adr     x1, isdir
        mov     x2, isdirlen
        b       7f
4:
        cmp     x0, #-36
        bne     5f
        adr     x1, toolong
        mov     x2, toolonglen
        b       7f
5:
        cmp     x0, #1
        bne     6f
        adr     x1, readerror
        mov     x2, readerrorlen
        b       7f
6:
        adr     x1, unknown
        mov     x2, unknownlen
7:
        mov     x0, #2
        mov     x8, #64
        svc     #0
        ret
        .size   write_error, .-write_error
