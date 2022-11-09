//File: Assignment 3
//Author: Minsu Kim 30068971
//Date: Oct. 14, 2022
//Description: This program will sort out an unsorted array through bubble sort method, and print out both sorted and unsorted arrays.

	size = 40						//Initializing the size of the array
	a_size = size * 4					//Allocating 40*4 bytes of memory for the array
	i_size = 4						//Allocating 4 bytes of memory for int i
	j_size = 4						//Allocating 4 bytes of memory for int j
	
	alloc = -(16 + i_size + j_size + a_size) & -16		//Allocting memory for the program.
	dealloc = -alloc

	i_s = 16						//Setting stack offsets for the variables used.
	j_s = 20
	a_s = 24

value_str:
	.string "v[%d]: %d\n"					//Initializing strings to print

sorted_str:
	.string "\nSorted Array:\n"

define(a_base_r, x19)						//Defining macros (using lots of "temp" variables but "temp", defined with w23 register is for int temp.)
define(i_r,w21)
define(j_r,w22)
define(temp,w23)
define(temp1, w24)
define(temp2, w25)
define(temp3, w26)
define(temp4, w27)
define(temp5, w28)

	fp .req x29						//Definining fp and lr
	lr .req x30

	.balign 4						//Aligning the program to 4 bytes
	.global main						//Making main function global

main:
	stp fp, lr, [sp, alloc]!				//Allocating "alloc" amount of memory and saving fp and lr to the stack
	mov fp, sp
	
	add a_base_r, fp, a_s					//Calculating for the base of the array address

	mov i_r, 0		
	str i_r, [fp, i_s]					//Storing value of i to the i_os offset stack	
	b loopTest

loopBody:
	ldr i_r, [fp, i_s]
	bl rand							//Calling random number generator
	and temp1, w0, 0xFF					//Logical and with the random number
	
	str temp1, [a_base_r, i_r, SXTW 2]			//Storing the random number to the array

	add i_r, i_r, 1						//Incrementing i by 1
	str i_r, [fp, i_s]

loopTest:
	ldr i_r, [fp,i_s]
	cmp i_r, size	
	str i_r, [fp,i_s]					//Comparing i to SIZE, where if it is less than we store the unsorted array
	b.lt loopBody

	mov i_r, 0
	str i_r, [fp, i_s]
	
	b printUnsortTest

printUnsort:
	ldr i_r, [fp, i_s]					//Loading the i variable value and the array value at index i
	ldr temp1, [a_base_r, i_r, SXTW 2]

	adrp x0, value_str
	add x0, x0, :lo12:value_str
	mov w1, i_r						//Printing the unsorted array
	mov w2, temp1
	bl printf

	add i_r, i_r, 1						//Incrementing i by 1
	str i_r, [fp, i_s]

printUnsortTest:
	ldr i_r, [fp,i_s]
	cmp i_r, size	
	str i_r,[fp,i_s]					//Comparing i to SIZE, where if it is less, then we print the unsorted array
	b.lt printUnsort

	mov temp, size						//Storing temp5 to be temp5 = SIZE -1
	sub temp5, temp, 1

	b outerLoopTest						//Branching to the outerloopTest

outerLoopBody:
	mov j_r, 1						//Intializing value of j to be 1 and storing it and calling the innerLoopTest
	str j_r, [fp, j_s]

	b innerLoopTest

innerLoopBody:
	sub temp2, j_r, 1					//Setting up temp2 = j - 1
	ldr temp3, [a_base_r, j_r, SXTW 2]			//Loading v[j] to temp3
	ldr temp4, [a_base_r, temp2, SXTW 2]			//Loading v[j-1] to temp4

	cmp temp4, temp3					//Comparing v[j-1] and v[j]
	b.le ifFalse						//If v[j-1] is less than or equal to, then it branches to ifFalse, where it failed the test of v[j-1] > v[j].

	mov temp, 0						//Resetting temp variable to 0
	mov temp, temp4						//temp = v[j-1]
	mov temp4, temp3					//v[j-1] = v[j]
	mov temp3, temp						//v[j] = temp

	str temp4, [a_base_r, temp2, SXTW 2]			//Storing the new value of v[j-1] at the j-1 index of the array
	str temp3, [a_base_r, j_r, SXTW 2]			//Storing the new value of v[j] at the j index of the array

ifFalse:
	add j_r, j_r, 1						//If the test condition fails, it will skip the logical sorting and increment j by 1
	str j_r, [fp, j_s]

innerLoopTest:
	ldr j_r, [fp, j_s]					//Loading j variable from the offset
	cmp j_r, temp5						//Comparing j variable to temp5 (SIZE - 1), where if it is less than or equal to it will enter the innerLoopBody again
	b.le innerLoopBody

	sub temp5, temp5, 1					//Decrementing temp5 by 1

outerLoopTest:
	cmp temp5, 0						//Comparing temp5 (i) to 0, where if it is greater or equal to, it will enter the outerLoopBody again and restart the loop
	b.ge outerLoopBody

	adrp x0, sorted_str					//Setting up sorted_str
	add x0, x0, :lo12:sorted_str
	bl printf						//Printing sorted_str string
	mov i_r, 0						//Resetting i variable to 0 and storing it
	str i_r, [fp, i_s]
	b printSortedTest					//Branching to printSortedTest
	
printSorted:
	ldr i_r, [fp, i_s]					//Loading the i variable
	ldr temp1, [a_base_r, i_r, SXTW 2]			//Loading the v[i] to temp1
	
	adrp x0, value_str
	add x0, x0, :lo12:value_str				//Printing the sorted array
	mov w1, i_r
	mov w2, temp1
	bl printf

	add i_r, i_r, 1						//Incrementing i by 1
	str i_r, [fp,i_s]

printSortedTest:
	cmp i_r, size						//Comparing i and size, where if it is less than it will print
	b.lt printSorted

exit:
	ldp fp, lr, [sp], dealloc				//Deallocating memory to exit properly
	ret
