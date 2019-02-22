#include "machine.h"
#include <stdio.h>

processor_8086 proc;

void machine_init_processor_8086() {
	for (int i = 0; i < MEM_SIZE; ++i)
		proc.mem[i] = 0;

	proc.a = 0;
	proc.b = 0;
	proc.c = 0;
	proc.d = 0;
	proc.e = 0;
	proc.h = 0;
	proc.l = 0;
	proc.m = 0;
	proc.pws = 0;
	proc.sp = 0;
}

void machine_print_mem(int from, int to) {
	if (from < 0) {
		printf("bad from value = %d\n", from);
		return;
	}
	if (to > MEM_SIZE) {
		printf("bad to value\n = %d\n", to);
		return;
	}

	for (int i = from; i < to; ++i)
		printf("%d:%d\n", i, proc.mem[i]);

}

void machine_print_all_reg() {
	printf("a 	= %d\n", proc.a);
	printf("b 	= %d\n", proc.b);
	printf("c 	= %d\n", proc.c);
	printf("d 	= %d\n", proc.d);
	printf("e 	= %d\n", proc.e);
	printf("h 	= %d\n", proc.h);
	printf("l 	= %d\n", proc.l);
	printf("m 	= %d\n", proc.m);
	printf("pws = %d\n", proc.pws);
	printf("sp 	= %d\n", proc.sp);

}

