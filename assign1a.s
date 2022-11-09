// File: Assignment 1 A
// Author: Minsu Kim 30068971
// Date: Sept.19, 2022
// Description: This file will do basic arithemics using no macros and utilitzing a pre-test loop, where the loop will be on top of the arithemic function.

        .data

str:    .string "The current value of x: %d\n The current value of y: %d\n The current maximum value: %d\n"		//Initializing string output

        .text

        .balign 4													//Aligining instructions by 4 bits
        .global main													//Making main function global

main:
        stp x29, x30, [sp,-16]!
        mov x29, sp

        mov x19, -10                    										//Initializing current value of x variable
        mov x20, 0                      										//Initializing current value of y variable
        mov x21, 0                     										 	//Initializing current value of maximum variable

        b loopTest													//Pre-test loop, where it tests the condition before executing the body of the loop

loopTest:
        cmp x19, 11													//Compares x variable to 11, where if x is less than 11, it will execute the body of the loop
        b.lt loopBody													//And if it is greater than or equal to 11, it will exit the program
        b exit

loopBody:
	mov x26, -4													//Setting temporary register to -4 as a constant
        mul x22, x19, x19												//x22 = x * x, so that x22 = x^2
        mul x22, x22, x19												//x22 = x22 * x, so that x22 = x^3
        mul x22, x22, x19												//x22 = x22 * x, so that x22 = x^4
        mul x22, x22, x26												//x22 = x22 * x26, so that x22 = -4x^4

	mov x26, 301													//Setting temporary register to 301 as a constant
        mul x23, x19, x19												//x23 = x * x, so that x23 = x^2
        mul x23, x23, x26												//x23 = x23 * x26, so that x23 = 301x^2

	mov x26, 56													//Setting temporary register to 56 as a constant
        mul x24, x19, x26												//x24 = x * 56, so that x24 = 56x

        mov x26, -103													//Setting temporary register to -103 as a constant
        add x25, x22, x23												//x25 = x22 + x23, so that x25 = -4x^4 + 301x^2
        add x25, x25, x24												//x25 = x25 + x24, so that x25 = -4x^4 + 301x^2 + 56x
	add x25, x25, x26												//x25 = x25 + x26, so that x25 = -4x^4 + 301x^2 + 56x - 103

        cmp x25, x21													//Comparing current y value to the current maximum value
        b.gt newMax													//If y is greater than the current value it will call newMax to replace the current max value to the current y value

        b print

newMax:
        mov x21, x25													//This function is called when the current y value is greater than the current max value, where the current max is replaced with the current y value
        b print														

print:
        adrp x0, str													//Setting up the string to be printed
        add x0, x0, :lo12:str												
        mov x1, x19													//Adds x value into the first argument
        mov x2, x25													//Adds y value to the second argument
        mov x3, x21													//Adds max value to the third argument

        bl printf													//Prints the string
        add x19, x19, 1													//Increments the value of x by 1

	b loopTest

exit:
        ldp x29, x30, [sp], 16												//Setting back the memory address to exit the program properly.
        ret
