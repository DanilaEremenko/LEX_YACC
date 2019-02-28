#include "machine.h"

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
	proc.psw = 0;
	proc.sp = 0;
}

void machine_print_mem(int from, int to) {
	if (from < 0) {
		printf("bad from value = %d\n", from);
		return;
	}
	if (to > MEM_SIZE - 1) {
		printf("bad to value\n = %d\n", to);
		return;
	}

	for (int i = from; i <= to; ++i)
		printf("%.3o:%.3o\n", i, proc.mem[i]);

}

void machine_print_mem_by_indexes(int indexes[], int indexes_len) {
	for (int i = 0; i < indexes_len; ++i)
		printf("%d:%o\n", indexes[i], proc.mem[OTD(indexes[i])]);

}



void machine_print_all_reg() {
	printf("a \t= %o\n", proc.a);
	printf("b \t= %o\n", proc.b);
	printf("c \t= %o\n", proc.c);
	printf("d \t= %o\n", proc.d);
	printf("e \t= %o\n", proc.e);
	printf("h \t= %o\n", proc.h);
	printf("l \t= %o\n", proc.l);
	printf("m \t= %o\n", proc.m);
	printf("pws\t= %o\n", proc.psw);
	printf("sp \t= %o\n", proc.sp);
	printf("f \t= %o\n", proc.f);

}

int machine_get_opcode_of_mnem(char *mnem) {
	if (!strcmp(mnem, "LXI"))
		return LXI_OP;
	else if (!strcmp(mnem, "MOV"))
		return MOV_OP;
	else if (!strcmp(mnem, "INX"))
		return INX_OP;
	else if (!strcmp(mnem, "HLT"))
		return HLT_OP;
	else
		printf("UNDEFINED MNEMONIC = %s\n", mnem);
	return -1;
}

int machine_get_code_of_reg(char *reg_name) {

	if (!strcmp(reg_name, "A"))
		return A_CODE;
	else if (!strcmp(reg_name, "B"))
		return B_CODE;
	else if (!strcmp(reg_name, "C"))
		return C_CODE;
	else if (!strcmp(reg_name, "D"))
		return D_CODE;
	else if (!strcmp(reg_name, "E"))
		return E_CODE;
	else if (!strcmp(reg_name, "H"))
		return H_CODE;
	else if (!strcmp(reg_name, "L"))
		return L_CODE;
	else if (!strcmp(reg_name, "M"))
		return M_CODE;
	else if (!strcmp(reg_name, "PSW"))
		return PSW_CODE;
	else if (!strcmp(reg_name, "SP"))
		return SP_CODE;
	else
		printf("UNDEFINED REG = %s\n", reg_name);

	return -1;

}

void machine_set_reg(char *reg_name, int number) {

	if (!strcmp(reg_name, "A"))
		proc.a = number;
	else if (!strcmp(reg_name, "B"))
		proc.b = number;
	else if (!strcmp(reg_name, "C"))
		proc.c = number;
	else if (!strcmp(reg_name, "D"))
		proc.d = number;
	else if (!strcmp(reg_name, "E"))
		proc.e = number;
	else if (!strcmp(reg_name, "H"))
		proc.h = number;
	else if (!strcmp(reg_name, "L"))
		proc.l = number;
	else if (!strcmp(reg_name, "M"))
		proc.m = number;
	else if (!strcmp(reg_name, "PWS"))
		proc.psw = number;
	else
		printf("UNDEFINED REG = %s\n", reg_name);

	return;

}

void machine_set_reg_pair(char *reg_name, int number_1, int number_2) {

	if (!strcmp(reg_name, "B")) {
		proc.b = number_2;
		proc.c = number_1;
	} else if (!strcmp(reg_name, "D")) {
		proc.d = number_2;
		proc.e = number_1;
	} else if (!strcmp(reg_name, "H")) {
		proc.h = number_2;
		proc.l = number_1;
	} else if (!strcmp(reg_name, "SP")) {
		proc.sp = (number_2 << 8) + number_1;
		proc.max_sp = proc.sp;
	} else
		printf("UNDEFINED REG PAIR = %s\n", reg_name);

	return;

}

int machine_get_reg(char *reg_name) {

	if (!strcmp(reg_name, "A"))
		return proc.a;
	else if (!strcmp(reg_name, "B"))
		return proc.b;
	else if (!strcmp(reg_name, "C"))
		return proc.c;
	else if (!strcmp(reg_name, "D"))
		return proc.d;
	else if (!strcmp(reg_name, "E"))
		return proc.e;
	else if (!strcmp(reg_name, "H"))
		return proc.h;
	else if (!strcmp(reg_name, "L"))
		return proc.l;
	else if (!strcmp(reg_name, "M"))
		return proc.m;
	else if (!strcmp(reg_name, "PSW"))
		return proc.psw;
	else if (!strcmp(reg_name, "SP"))
		return proc.sp;
	else
		printf("UNDEFINED REG%s\n", reg_name);

	return -1;

}

void machine_update_reg_pair(char *reg_name) {
	if (!strcmp(reg_name, "B")) {
		proc.reg_pair[0] = proc.b;
		proc.reg_pair[1] = proc.c;
	} else if (!strcmp(reg_name, "D")) {
		proc.reg_pair[0] = proc.d;
		proc.reg_pair[1] = proc.e;
	} else if (!strcmp(reg_name, "H")) {
		proc.reg_pair[0] = proc.h;
		proc.reg_pair[1] = proc.l;
	} else if (!strcmp(reg_name, "PSW")) {
		proc.reg_pair[0] = proc.a;
		proc.reg_pair[1] = proc.f;
	} else
		printf("UNDEFINED REG PAIR = %s\n", reg_name);

	return;

}

void machine_add_reg(char *reg_name, int num) {
	if (!strcmp(reg_name, "A"))
		proc.a += num;
	else if (!strcmp(reg_name, "B"))
		proc.b += num;
	else if (!strcmp(reg_name, "C"))
		proc.c += num;
	else if (!strcmp(reg_name, "D"))
		proc.d += num;
	else if (!strcmp(reg_name, "E"))
		proc.e += num;
	else if (!strcmp(reg_name, "H"))
		proc.h += num;
	else if (!strcmp(reg_name, "L"))
		proc.l += num;
	else if (!strcmp(reg_name, "M"))
		proc.m += num;
	else if (!strcmp(reg_name, "PWS"))
		proc.psw += num;
	else if (!strcmp(reg_name, "SP"))
		proc.sp += num;
	else
		printf("UNDEFINED REG%s\n", reg_name);

	return;

}

int OTD(int oct) {
	int dec = 0;
	int mult = 1;

	while (oct != 0) {
		dec += oct % 10 * mult;
		mult *= 8;
		oct /= 10;
	}

	return dec;

}

void print_inf_8080(int cell_num) {
	printf("%d:%o \t(s = %d, z = %d, a = %d, p = %d, c = %d)\n", cell_num,
			proc.mem[cell_num], (proc.f >> 7) & 1, (proc.f >> 6) & 1,
			(proc.f >> 4) & 1, (proc.f >> 2) & 1, proc.f & 1);
}
