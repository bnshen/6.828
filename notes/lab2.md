# how eaxtly does JOS manage pyhsical memory?(from kernel's perspective)

how kernel set mapping:
1. kern\_pgdir pagetable level 2
2. pages pagetable level 1
3. PADDR() and KADDR() are only used for initial kernal memory mapping

---

* map 0xf0000000-0xffffffff to 0x0-0x0fffffff
* map UPAGE-UPAGE+npage\*sizeof\(\*\) or 0xef000000-0xef400000 to PADDR(pages) or at the end of kernal's bss seg
* map virtual kernal stack to bootstack

---


when the start:
1. linker link the kernel to address 0xf0000000
2. create the initial mapping: 0xf0000000 to 0x0 for 4MB and load the kernel
3. kernel create mapping: see above
