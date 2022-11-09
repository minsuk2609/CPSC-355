//File: Assignment 2 Version C
//Author: Minsu Kim 30068971
//Date: Oct.1, 2022
//Description: This assignment will take binary 0x01FF01FF and go through an algorithm that will reverse it and print both the original and the reversed.

define(x_r, w19)
define(y_r, w20)
define(t1_r, w21)										//Initializing vairbles and defining macros to make the code easier to read and follow along.
define(t2_r, w22)
define(t3_r, w24)
define(t4_r, w25)
	
		.data

out_str:	.string  "original: 0x%08X reversed: 0x%08X\n"					//Initializing string output

		.text
		
		.balign 4									//Aligning the program by 4 bytes
		.global main									//Making main function global

main:
	stp x29, x30, [sp,-16]!									
	mov x29, sp

	mov x_r, 0x01FF01FF									//Setting x variable as 0x01FF01FF

s1:
	and t1_r, x_r, 0x55555555								//and instruction runs the logical and operation to do x & 0x55555555
	lsl t1_r, t1_r, 1									//Logical shift left the t1 variable by 1, completing t1 = (x & 0x55555555) << 1

	lsr t2_r, x_r, 1									//Logical shift right the x variable and storing it in t2 variable to do x >> 1
	and t2_r, t2_r, 0x55555555								//Logical and operation on t2 variable with 0x55555555 to complete t2 = (x >> 1) & 0x55555555

	orr y_r, t1_r, t2_r									//Logical or operation on t1 and t2 and storing the value into y variable

s2:
	and t1_r, y_r, 0x33333333								//Logical and on y variable and 0x33333333 to do y & 0x33333333
	lsl t1_r, t1_r, 2									//Logical shift left t1 variable by 2, to complete t1 = (y & 0x33333333) << 2
	
	lsr t2_r, y_r, 2									//Logical shift right on y variable by 2 to do y >> 2 
	and t2_r, t2_r, 0x33333333								//Logical and operation on t2 to complete t2 = (y >> 2) & 0x33333333

	orr y_r, t1_r, t2_r									//Logical or operation on t1 and t2 and storing it in y variable

s3:
	and t1_r, y_r, 0x0F0F0F0F								//Logical and operation on y variable with 0x0F0F0F0F to do y & 0x0F0F0F0F
	lsl t1_r, t1_r, 4									//Logical shift left t1 variable by 4 to complete t1 = (y & 0x0F0F0F0F) << 4
	
	lsr t2_r, y_r, 4									//Logical shift right on y variable by 4
	and t2_r, t2_r, 0x0F0F0F0F								//Logical and operation on t2 and 0x0F0F0F0F to complete t2 = (y >> 4) & 0x0F0F0F0F

	orr y_r, t1_r, t2_r									//Logical or operation on t1 and t2 and storing the answer in y variable

s4:
	lsl t1_r, y_r, 24									//Logical shift left on y variable by 24 and storing it in t1 variable
	
	and t2_r, y_r, 0xFF00									//Logical and operation on y variable and 0xFF00 and storing it in t2
	lsl t2_r, t2_r, 8									//Logical shift left on t2 by 8
	
	lsr t3_r, y_r, 8									//Logical shift right on y variable by 8 and storing it in t3 variable
	and t3_r, t3_r, 0xFF00									//Logical and operation on t3 variable with 0xFF00

	lsr t4_r, y_r, 24									//Logical shift left of y variable by 24 and storing it in t4 variable

	orr y_r, t1_r, t2_r									//Logical or operation on t1 and t2 and storing it in y (y = t1 | t2)
	orr y_r, y_r, t3_r									//Logical or operation on y and t3 and storing it in y (y = t1 | t2 | t3)
	orr y_r, y_r, t4_r									//Logical or operation on y and t4 and storing it in y (y = t1 | t2 | t3 | t4)

	adrp x0, out_str									//Setting up out_str to print
	add x0, x0, :lo12:out_str
	mov w1, x_r										//Moving x variable to the first input
	mov w2, y_r										//Moving y variable to the second input

	bl printf										//Printing the string

exit:
	ldp x29, x30, [sp], 16									//Setting up to exit the program properly
	ret		

