/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

#include <kern/picirq.h>


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
	.text;\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps;	\
	.data;	\
		.long name;

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.text;\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps;	\
	.data;\
	.long name;


.data
.globl handlers
handlers:
TRAPHANDLER_NOEC(handler0, T_DIVIDE)
TRAPHANDLER_NOEC(handler1, T_DEBUG)
TRAPHANDLER_NOEC(handler2, T_NMI)
TRAPHANDLER_NOEC(handler3, T_BRKPT)
TRAPHANDLER_NOEC(handler4, T_OFLOW)
TRAPHANDLER_NOEC(handler5, T_BOUND)
TRAPHANDLER_NOEC(handler6, T_ILLOP)
TRAPHANDLER_NOEC(handler7, T_DEVICE)
TRAPHANDLER(handler8, T_DBLFLT)
TRAPHANDLER(handler9, 9) // 9 deprecated since 386
TRAPHANDLER(handler10, T_TSS)
TRAPHANDLER(handler11, T_SEGNP)
TRAPHANDLER(handler12, T_STACK)
TRAPHANDLER(handler13, T_GPFLT)
TRAPHANDLER(handler14, T_PGFLT)
TRAPHANDLER(handler15, 15) // 15 reserved by intel
TRAPHANDLER_NOEC(handler16, T_FPERR)
TRAPHANDLER(handler17, T_ALIGN)
TRAPHANDLER_NOEC(handler18, T_MCHK)
TRAPHANDLER_NOEC(handler19, T_SIMDERR)
TRAPHANDLER_NOEC(handler48, T_SYSCALL)

TRAPHANDLER(handler21, IRQ_OFFSET + IRQ_TIMER)
TRAPHANDLER(handler22, IRQ_OFFSET + IRQ_KBD)
TRAPHANDLER(handler23, IRQ_OFFSET + IRQ_SERIAL)
TRAPHANDLER(handler24, IRQ_OFFSET + IRQ_SPURIOUS)
TRAPHANDLER(handler25, IRQ_OFFSET + IRQ_IDE)
TRAPHANDLER(handler26, IRQ_OFFSET + IRQ_ERROR)


	
	


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
		
