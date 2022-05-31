/*
 *	Remove from each word of the string the characters in even places.
 *	Data input - standard input ("from the keyboard").
 *	The output is a file.
 *	The way to pass parameters is through dialog interaction with the user.
 */
	.arch	armv8-a
	.data
msg_input:
	.string	"Input filename for write\n"
	.equ	len_input, .-msg_input
msg_rewrite:
	.string	"File exists. Rewrite(y/n)?\n"
	.equ	len_rewrite, .-msg_rewrite
answer:
	.skip	3
file_name:
	.skip	1024
	.align	3
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
	mov	x0, #0			// x0 is erorr
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
	sub	x2, x0, #1		// x2 is len without \n
	mov	x0, #0
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

	mov	x0, #1			//
	adr	x1, msg_rewrite		//
	mov	x2, len_rewrite		//
	mov	x8, #64			//
	svc	#0			// print msg_rewrite

	mov	x0, #0			//
	adr	x1, answer		//
	mov	x2, #3			//
	mov	x8, #63			//
	svc	#0			// read answer
	cmp	x0, #2			// error?
	beq	3f			//
	mov	x0, #-17		//
	b	6f			//
3:
	adr	x1, answer		//
	ldrb	w0, [x1]		//
	cmp	w0, 'y'			//
	beq	4f			// compare answer
	mov	x0, #-17		// if not yes it is error
	b	6f			//
4:
	mov	x0, #-200		//
	adr	x1, file_name		//
	mov	x2, #0x201		//
	mov	x8, #56			//
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
	cbnz	x9, 6f
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
	.equ	even, 40
	.equ	first, 48
	.equ	input, 56
	.equ	output, 120
	.text
	.align	2
work:
	mov	x16, #184		// stack frame
	sub	sp, sp, x16		//
	stp	x29, x30, [sp]
	mov	x29, sp
	str	x0, [x29, fd]
	str	xzr, [x29, flag]
	str	xzr, [x29, even]

	mov	x16, #1
	str	x16, [x29, first]
0:
	mov	x0, #1			//
	add	x1, x29, input		//
	mov	x2, #64			//
	mov	x8, #63			//
	svc	#0			// read input 64 chars

	cmp	x0, #0			// check errors
	blt	8f			//
	beq	9f			//

	add	x0, x0, x29
	add	x0, x0, input		// x0 is end of input

	ldr	x1, [x29, flag]		// x1 is flag
	add	x3, x29, input		// x3 is input index
	mov	x16, output		//
	add	x4, x29, x16		// x4 is output index
	ldr	x5, [x29, even]		// x5 is even
	ldr	x6, [x29, first]	// x6 is first
	mov	w7, ' '			// w7 is space

1:					// compare
	cmp	x3, x0			// is buffer over
	bge	6f			//

	ldrb	w2, [x3], #1		// load char

	cbz	w2, 2f			// char is \0 or \n
	cmp	w2, '\n'		//
	beq	2f			//

	cmp	w2, ' '			// char is ' ' or '\t'
	beq	3f			//
	cmp	w2, '\t'		//
	beq	3f			//

	cbz	x1, 4f			// flag is false

	cbz	x5, 5f			// even is false
	mov	x5, #0			// set even false
	b	1b

2:					// \n & \0
	mov	x6, #1			// first is true
	mov	x5, #0			// even is false
	mov	x1, #0			// flag is false
	strb	w2, [x4], #1		// store char
	b	1b

3:					// ' ' & \t
	mov	x1, #0			// flag is false
	mov	x5, #0			// even is false
	b	1b
4:					// flag is false and word started
	mov	x1, #1			// flag is true
	cmp	x6, #1			// is first?
	mov	x6, #0			// first is false
	beq	5f			// true
	strb	w7, [x4], #1		// store space
5:					// inside word
	strb	w2, [x4], #1		// store char
	mov	x5, #1			// even is true
	b	1b

6:					//buf is over
	str	x1, [x29, flag]		//
	str	x5, [x29, even]		// store flags
	str	x6, [x29, first]	//
	mov	x16, output
	add	x1, x29, x16		// x1 is start of output
	sub	x2, x4, x1		// x2 is index-start of output
	cbz	x2, 0b			// nothing to store
	str	x2, [x29, tmp]
7:
	ldr	x0, [x29, fd]		//
	mov	x8, #64			//
	svc	#0			// write to file
	cmp	x0, #0			// errors?
	blt	8f			//
	ldr	x2, [x29, tmp]
	cmp	x0, x2			// writen == stored ?
	beq	0b			//
	mov	x16, output		//
	add	x1, x29, x16		//
	add	x1, x1, x0		// repeat 6:
	sub	x2, x2, x0		//
	str	x2, [x29, tmp]		//
	b	7b
8:					// error
	str	x0, [x29, tmp]		//
	ldr	x0, [x29, fd]		//
	mov	x1, #0			//
	mov	x8, #46			//
	svc	#0			// clear file
	ldr	x0, [x29, tmp]
9:					//return
	ldp	x29, x30, [sp]		//
	mov	x16, #184		//
	add	sp, sp, x16		//
	ret				//
	.size	work, .-work

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
write_error:
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
