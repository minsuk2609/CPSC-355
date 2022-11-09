//File: Assingment 4
//Author: Minsu Kim
//Date: Nov 3, 2022
//Description: This assignment will translate the provided C code from the assignment outline and use the techniques of nested structures and structures to create a cuboid
//and create two cuboids with different dimensions

define(FALSE, 0)					//Defining macros for FALSE and TRUE values
define(TRUE, 1)

	px_s = 0					//Creating offset for point method int x
	py_s = 4					//Creating offset for point method int y
	origin_s = 0					//Creating offset for struct point origin

	p_size = 8					//Creating size of point method

	width_s = 0					//Creating offset for dimension method int width
	length_s = 4					//Creating offset for dimension method int length
	base_s = 8					//Creating offset for struct dimension base

	dimension_size = 8				//Creating size for dimension method

	base_s = 16					//Creating offset for struct dimension base	
	result_s = 20					//Creating offset for result variable

	height_s = 24					//Creating offset for method cuboid int height
	volume_s = 36					//Creating offset for method cuboid int volume

	first_s = 16					//Creating offset for first cuboid
	second_s = 36					//Creating offset for second cuboid

	first_size = 20					//Creating size for first cuboid
	second_size = 20				//Creating size for second cuboid

	c_s = 32					//Creating offset for struct cuboid

	c_size = 32					//Creating size for struct cuboid
	
cube_str:
	.string "\torigin = (%d, %d) Base width = %d Base length = %d Height = %d Volume = %d\n"

initial_str:
	.string "Initial cuboid values: \n"

changed_str:
	.string "\nChanged cuboid values:\n"		//Defining strings to print

firstC_str:
	.string "Cuboid first: "

secondC_str:
	.string "Cuboid second: "

	
	fp .req x29					//Renaming x29 to fp
	lr .req x30					//Renaming x30 to lr

	.balign 4					//Aligning the program by 4 bytes
	.global main					//Making main function global
	
	newCuboid_alloc = -(16 + c_size) & -16		//Setting allocation of memory for newCuboid method
	newCuboid_dealloc = -newCuboid_alloc		//Setting deallocation
	
newCuboid:
	stp fp, lr, [sp, newCuboid_alloc]!
	mov fp, sp

	str wzr, [x8, origin_s + px_s]			//Stores 0 to c.origin.x
	str wzr, [x8, origin_s + py_s]			//Stores 0 to c.origin.y

	mov w9, 2				
	str w9, [x8, base_s + width_s]			//Storing 2 to c.base.width
	
	mov w10, 2
	str w10, [x8, base_s + length_s]		//Storing 2 to c.base.length

	mov w11, 3
	str w11, [x8, height_s]				//Storing 3 to c.height

	mul w12, w9, w10 				//w12 = c.base.width * c.base.length
	mul w12, w12, w11				//w12 = w12 * c.height = c.base.width * c.base.length * c.height
	str w12, [x8, volume_s]				//Storing w12 into c.volume

	ldp fp, lr, [sp], newCuboid_dealloc		//Deallocating memory for the upcoming functions
	ret

	move_alloc = -(16 + first_size + second_size) & -16
	move_dealloc = -move_alloc			//Allocating memory for the move method
move:
	stp fp, lr, [sp, move_alloc]!			
	mov fp, sp

	ldr w9, [x8, origin_s + px_s]			//Loading c.origin.x into w9
	add w9, w9, w1					//Incrementing w9 by input deltaX
	str w9, [x8, origin_s + px_s]			//Storing the incremented w9 back into c.origin.x

	ldr w10, [x8, origin_s + py_s]			//Loading c.origin.y into w10
	add w10, w10, w2				//Incrementing w10 by input deltaY
	str w9, [x8, origin_s + py_s]			//Storing the incremented w10 back into c.origin.y

	ldp fp, lr, [sp], move_dealloc			//Deallocating memory for the upcoming functions
	ret

	
	scale_alloc = -(16 + c_size) & -16		//Allocating memory for scale method
	scale_dealloc = -scale_alloc			//Setting deallocation for scale method
scale:
	stp fp, lr, [sp, scale_alloc]!
	mov fp, lr

	ldr w9, [x8, base_s + width_s]			//Loading c.base.width to w9
	mul w9, w9, w1					//Multiplying w9 by the input factor
	str w9, [x8, base_s + width_s]			//Storing the multiplied w9 back into c.base.width

	ldr w10, [x8, base_s + length_s]		//Loading c.base.length to w10
	mul w10, w10, w1				//Multiplying w10 by the input factor
	str w10, [x8, base_s + length_s]		//Storing the multiplied w10 back into c.base.length
	
	ldr w11, [x8, height_s]				//Loading c.height into w11
	mul w11, w11, w1				//Multiplying w11 by the input factor
	str w11, [x8, height_s]				//Storing the multipled w11 back into c.height

	mul w12, w9, w10				//Multiplying c.base.width * c.base.length into w12
	mul w12, w12, w11				//Multiplying w12 by c.height and storing into w12
	str w12, [x8, volume_s]				//Storing w12 into c.volume

	ldp fp, lr, [sp], scale_dealloc			//Deallocating memory for the upcoming functions
	ret

	printCuboid_alloc = -(16 + c_size) & -16	//Allocating memory for printCuboid function
	printCuboid_dealloc = -printCuboid_alloc	//Setting deallocating for printCuboid function
printCuboid:
	stp fp, lr, [sp, printCuboid_alloc]!
	mov fp, sp

	adrp x0, cube_str				//Loading cube_str string
	add x0, x0, :lo12:cube_str		
	ldr w1, [x8, origin_s + px_s]			//Setting first argument as c.origin.x
	ldr w2, [x8, origin_s + py_s]			//Setting second argument as c.origin.y
	ldr w3, [x8, base_s + width_s]			//Setting third argument as c.base.width
	ldr w4, [x8, base_s + length_s]			//Setting fourth argument as c.base.length
	ldr w5, [x8, height_s]				//Setting fifth argument as c.height
	ldr w6, [x8, volume_s]				//Setting sixth argument as c.volume
	bl printf					//Printing the string with loaded arguments

	ldp fp, lr, [sp], printCuboid_dealloc		//Deallocating memory for the upcoming functions
	ret

	equalSize_alloc = -(16 + first_size + second_size) & -16
	equalSize_dealloc = -equalSize_alloc		//Setting allocation and deallocation for equalSize method
equalSize:
	stp fp, lr, [sp, equalSize_alloc]!
	mov fp, sp

	mov w9, FALSE					//Initially setting w9 to be false (0)

	ldr w10, [x23, base_s + width_s]		//Loading c1.base.width to w10
	ldr w11, [x24, base_s + width_s]		//Loading c2.base.width to w11
	
	ldr w12, [x23, base_s + length_s]		//Loading c1.base.length to w12
	ldr w13, [x24, base_s + length_s]		//Loading c2.base.length to w13

	ldr w14, [x23, height_s]			//Loading c1.height to w14
	ldr w15, [x24, height_s]			//Loading c2.height to w15

	cmp w10, w11					//Comparing c1.base.width to c2.base.width
	b.ne end					//If not equal, it will skip to end method of equalSize method
ifTrue1:
	cmp w12, w13					//If equal, it will then compare c1.base.length to c2.base.length
	b.ne end					//If true, it will continue to ifTrue2, otherwise it will go to end section
ifTrue2:
	cmp w14, w15					//If equal, it will then compare c1.height and c2.height
	b.ne end					//If equal it will set w9 as TRUE rather than false

	mov w9, TRUE

end:	
	str w9, [fp, result_s]				//Stores w9

	ldp fp, lr, [sp], equalSize_dealloc		//Deallocating memory for the upcoming functions
	ret

	main_alloc = -(16 + first_size + second_size) & -16
	main_dealloc = -main_alloc			//Setting allocation and deallocation for main function
main:
	stp fp, lr, [sp, main_alloc]!
	mov fp, sp

	add x23, fp, first_s				//Adding fp and first_s offset and storing it into x23 as a pointer
	mov x8, x23					//Moving x23 into x8 as the base address
	bl newCuboid					//Branch linking to newCuboid to make the first cuboid

	add x24, fp, second_s				//Adding fp and second_s offset and storing it into x24 as a pointer
	mov x8, x24					//Moving x24 into x8 as the base address
	bl newCuboid					//Branch linking to newCuboid to make the second cuboid

	adrp x0, initial_str				//Setting up inital_str and printing
	add x0, x0, :lo12:initial_str
	bl printf

	adrp x0, firstC_str				//Setting firstC_str and printing
	add x0, x0, :lo12:firstC_str
	bl printf
	mov x8, x23					//Moving x23 to x8 and calling printCuboid
	bl printCuboid

	adrp x0, secondC_str				//Setting secondC_str and printing
	add x0, x0, :lo12:secondC_str
	bl printf
	mov x8, x24					//Moving x24 to x8 and calling printCuboid
	bl printCuboid

	bl equalSize					//Branch linking to equalSize

	ldr w9, [fp, result_s]				//Loading the result of equalSize into w9

	cmp w9, TRUE					//Comparing w9 to TRUE and if it is equal it will branch straight to print and not make any changes	
	b.eq print

	mov x8, x23					//Moving x23 the first cuboid, into x8 for move method
	mov w1, 3					//Setting argument 1 as 3
	mov w2, -6					//Setting argument 2 as -6
	bl move						//Branch linking to move method
	
	mov x8, x24					//Setting x24 the second cuboid, into x8 for scale method
	mov w1, 4					//Setting argument 1 as 4
	bl scale					//Branch linking to scale method

print:
	adrp x0, changed_str				//Setting and printing changed_str
	add x0, x0, :lo12:changed_str
	bl printf

	adrp x0, firstC_str				//Setting up firstC_str and printing
	add x0, x0, :lo12:firstC_str
	bl printf
	mov x8, x23					//Setting x23 the first cuboid to x8 and branch linking to printCuboid method
	bl printCuboid

	adrp x0, secondC_str				//Setting up secondC_str and printing
	add x0, x0, :lo12:secondC_str
	bl printf
	mov x8, x24					//Setting x24 the second cuboid to x8 and branch linking to printCuboid method
	bl printCuboid

exit:
	ldp fp, lr, [sp], main_dealloc			//Deallocating memory from main function and exiting the program
	ret
