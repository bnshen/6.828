/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>



###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.data
TRAPHANDLER_NOEC(handler0,0)
TRAPHANDLER(handler1,1)
TRAPHANDLER(handler2,2)
TRAPHANDLER(handler3,3)
TRAPHANDLER(handler4,4)
TRAPHANDLER(handler5,5)
TRAPHANDLER(handler6,6)
TRAPHANDLER(handler7,7)
TRAPHANDLER(handler8,8)
TRAPHANDLER(handler9,9)
TRAPHANDLER(handler10,10)
TRAPHANDLER(handler11,11)
TRAPHANDLER(handler12,12)
TRAPHANDLER(handler13,13)
TRAPHANDLER(handler14,14)
TRAPHANDLER(handler15,15)
TRAPHANDLER(handler16,16)
TRAPHANDLER(handler17,17)
TRAPHANDLER(handler18,18)
TRAPHANDLER(handler19,19)

.data
.globl handlers
handlers:
	.long handler0
	.long handler1
	.long handler2
	.long handler3
	.long handler4
	.long handler5
	.long handler6
	.long handler7
	.long handler8
	.long handler9
	.long handler10
	.long handler11
	.long handler12
	.long handler13
	.long handler14
	.long handler15
	.long handler16
	.long handler17
	.long handler18
	.long handler19
	
	


/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */



/*
 * Lab 3: Your code here for _alltraps
 */

.data
.globl _alltraps
_alltraps:
	pushl %ds
  	pushl %es
	pushal

	movw $(GD_KD), %ax
	movw %ax, %ds
	movw %ax, %es

	push %esp
	call trap
		
