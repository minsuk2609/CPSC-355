//File: Assignment 1 B
//Author: Minsu Kim 30068971
//Date: September 21, 2022
//Description: This file will run a simple algorthimic process but it will use macros and use a pre-test loop at the bottom to optimize the code.

define(x_v, x19)
define(y_v, x20)											//Defining macros to use later in the program
define(max_v, x21)
define(temp, x23)
define(temp_x1, x22)
define(temp_x2, x24)

	.data

str:	.string "The value of x is: %d\nThe value of y is: %d\nThe maximum value is: %d\n"		//Initializing string output for the program

	.text

	.balign 4											//Aligning the instructions by 4 bits
	.global main											//Making main function global

main:
	stp x29, x30, [sp, -16]!									//Setting up the program to be executed
	mov x29, sp		

	mov x_v, -10											//Setting up x variable to equal -10
	mov y_v, 0											//Setting y variable to equal 0
	mov max_v, 0											//Setting max variable to equal 0

	b loopTest											//Pre-testing the loop, so the conditions are checked before the body of the loop is executed

loopBody:
	
	mov temp, -4											//Setting up temporary variable temp = -4, to use as a constant
	mul temp_x1, x_v, x_v										//Setting temp_x1 = x * x, so that temp_x1 = x^2
	mul temp_x1, temp_x1, x_v									//temp_x1 = temp_x1 * x, so that temp_x1 = x^3
	mul temp_x1, temp_x1, x_v									//temp_x1 = temp_x1 * x, so that temp_x1 = x^4
	mul temp_x1, temp_x1, temp									//temp_x1 = temp_x1 * temp, so that temp_x1 = -4x^4

	mov temp, 301											//Setting up temporrary variable temp  = 301, to use as a constant
	mul temp_x2, x_v, x_v										//temp_x2 = x * x, so that temp_x2 = x^2
	madd y_v, temp_x2, temp, temp_x1								//Multiplying and adding, so that y = (temp_x2 * temp) + temp_x1, so that y = -4x^4 + 301x^2

	mov temp, 56											//Setting temporary variable temp = 56, to use as a constant
	madd y_v, x_v, temp, y_v									//Multiplying and adding, so that y = (temp * x) + y, so that y = -4x^4 + 301x^2 + 56x

	mov temp, -103											//Setting temporary variable temp = -103, to use as a constant
	add y_v, y_v, temp										//Addition instruction on y = y + temp, so that y = -4x^4 + 301x^2 + 56x - 103

	b checkMax											//Branching to checkMax to check if the current y value is greater than the current max value

checkMax:
	cmp y_v, max_v											//Compares y value to the current max value, and if it is less, it will call print function 
	b.lt print

	mov max_v, y_v											//If the y value is greater than the current max value, it will replace the current max value to the current y value

	b print												//Calls the print function

print:
	adrp x0, str											//Loads the string to be printed
	add x0, x0, :lo12:str
	mov x1, x_v											//Setting the first arugment to x
	mov x2, y_v											//Setting the second argument to y
	mov x3, max_v											//Setting the third argument to the max value
	bl printf											//Printing the string
	
	add x_v, x_v, 1											//Increments the value of x by 1 and then calls the loopTest again to be tested
	b loopTest
			
loopTest:
	cmp x_v, 11											//Compares the x value to 11, where if it is less than 11 it will execute the body of the function
	b.lt loopBody											//If it is greater it will move to exit function to end the program


exit:
	ldp x29, x30, [sp], 16										//Setting up to exit the program properly
	ret
