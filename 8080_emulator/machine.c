#include "machine.h"

processor_8086 proc;

int test_mem[MEM_SIZE];

/*PRINTS--------------------------------------------*/
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

void print_inf_8080(int cell_num) {
	printf("%d:%o \t(s = %d, z = %d, a = %d, p = %d, c = %d)\n", cell_num,
			proc.mem[cell_num], (proc.f >> 7) & 1, (proc.f >> 6) & 1,
			(proc.f >> 4) & 1, (proc.f >> 2) & 1, proc.f & 1);
}

/*SETTERS-------------------------------------------*/
void machine_set_reg_pair(int hash, int reg_code, int number_1, int number_2) {
	switch (reg_code) {
	case B_CODE:
		proc.b = number_2;
		proc.c = number_1;
		break;
	case D_CODE:
		proc.d = number_2;
		proc.e = number_1;
		break;
	case H_CODE:
		proc.h = number_2;
		proc.l = number_1;
		break;
	case M_CODE:
		if (hash == LXI_H) {
			proc.sp = (number_2 << 8) + number_1;
			proc.max_sp = proc.sp;
		} else if (hash == POP_H) {
			proc.a = number_2;
			proc.f = number_1;
		}
		break;
	case A_CODE:
		proc.a = number_2;
		proc.f = number_1;
		break;
	default:
		printf("Undefined reg code in machine_set_reg_pair\n");

	}
	return;

}

int get_reg_by_code(int code) {
	switch (code) {
	case A_CODE:
		return proc.a;
	case B_CODE:
		return proc.b;
	case C_CODE:
		return proc.c;
	case D_CODE:
		return proc.d;
	case E_CODE:
		return proc.e;
	case H_CODE:
		return proc.h;
	case L_CODE:
		return proc.l;
	case M_CODE:
		return proc.mem[proc.h << 8 | proc.l];
	default:
		printf("undefined reg = %d (get_reg_by_code)\n", code);
		return -999;

	}

}

void set_reg_by_code(int code, int val) {
	switch (code) {
	case A_CODE:
		proc.a = val;
		return;
	case B_CODE:
		proc.b = val;
		return;
	case C_CODE:
		proc.c = val;
		return;
	case D_CODE:
		proc.d = val;
		return;
	case E_CODE:
		proc.e = val;
		return;
	case H_CODE:
		proc.h = val;
		return;
	case L_CODE:
		proc.l = val;
		return;
	case M_CODE:
		proc.mem[(proc.h << 8) | proc.l] = val;
		return;
	default:
		printf("undefined reg = %d (get_reg_by_code)\n", code);
		return;
	}

}

void machine_add_reg(char *reg_name, int num, int pc) {
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
	else if (!strcmp(reg_name, "PSW"))
		proc.psw += num;
	else if (!strcmp(reg_name, "SP"))
		proc.sp += num;
	else
		printf("UNDEFINED REG%s\n", reg_name);

	return;

}

/*GETTERS-------------------------------------------*/
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

void machine_update_reg_pair(int code, int pc) {
	switch (code) {
	case B_CODE:
		proc.reg_pair[0] = proc.b;
		proc.reg_pair[1] = proc.c;
		break;
	case D_CODE:
		proc.reg_pair[0] = proc.d;
		proc.reg_pair[1] = proc.e;
		break;
	case H_CODE:
		proc.reg_pair[0] = proc.h;
		proc.reg_pair[1] = proc.l;
		break;
	case M_CODE:
		proc.reg_pair[0] = proc.a;
		proc.reg_pair[1] = proc.f;
		break;
	case A_CODE:
		proc.reg_pair[0] = proc.a;
		proc.reg_pair[1] = proc.f;
		break;
	default:
		printf("%o:UNDEFINED REG%d\n", code, pc);

	}
	return;

}

/*CONVERTERS----------------------------------------*/
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

/*SSEG----------------------------------------------*/
int sseg_convert(int num) {
	switch (num) {
	case 0:
		return SSEG_0;
	case 1:
		return SSEG_1;
	case 2:
		return SSEG_2;
	case 3:
		return SSEG_3;
	case 4:
		return SSEG_4;
	case 5:
		return SSEG_5;
	case 6:
		return SSEG_6;
	case 7:
		return SSEG_7;
	}
	return 0;
}

void sseg_print(int sseg) {

	if (sseg & 1)
		printf(" _");
	printf("\n");
	/*---------------------------*/
	if ((sseg >> 5) & 1)
		printf("|");
	else
		printf(" ");

	/*---------------------------*/

	if ((sseg >> 6) & 1)
		printf("_");
	else
		printf(" ");
	/*---------------------------*/

	if ((sseg >> 1) & 1)
		printf("|");
	printf("\n");
	/*---------------------------*/

	if ((sseg >> 4) & 1)
		printf("|");
	else
		printf(" ");
	/*---------------------------*/

	if ((sseg >> 3) & 1)
		printf("_");
	else
		printf(" ");
	/*---------------------------*/

	if ((sseg >> 2) & 1)
		printf("|");
	printf("\n");

	/*---------------------------*/

}
/*TESTS---------------------------------------------*/
void assert_8080(int condition, int addres, char *mess) {
	if (!condition) {
		printf("________\n");
		printf("%o:assertion error, %s, exiting...\n", addres, mess);
		exit(42);
	}
}

void test_assert_8080(int expected, int val, int addres,char *mess) {
	if (expected!=val) {
		printf("________\n");
		printf("%o:assertion error, val = %o, expected = %o, %s, exiting...\n", addres,val,expected, mess);
		exit(42);
	}
}
void assert_val_8080(int val, int pc) {
	assert_8080(val <= MAX_VAL, pc, "proc.mem[pc] > MAX_VAL");
	assert_8080(val >= MIN_VAL, pc, "proc.mem[pc] > MAX_VAL");
}

/*MAIN PART-----------------------------------------*/
int fix_reg_overflow(int reg_code) {
	int ovfl = 0;
	switch (reg_code) {
	case A_CODE:
		FIX_OVFL(proc.a,ovfl);
		break;
	case B_CODE:
		FIX_OVFL(proc.b,ovfl);
		break;
	case C_CODE:
		FIX_OVFL(proc.c,ovfl);
		break;
	case D_CODE:
		FIX_OVFL(proc.d,ovfl);
		break;
	case E_CODE:
		FIX_OVFL(proc.e,ovfl);
		break;
	case H_CODE:
		FIX_OVFL(proc.h,ovfl);
		break;
	case L_CODE:
		FIX_OVFL(proc.l,ovfl);
		break;
	}
	return ovfl;

}

/*execute while proc.hashs[pc] != HLT*/
void execute_all(int *from, int *to, int ft_size) {
//	int attach_var = 0;
//	while (!attach_var)
//		attach_var = 0;

	int verbose = 1;

	/*for flags*/
	int ovfl = 0;
	int old_a;
	int var;

	/*static indication*/
	int stat_ind_allowed = 0;

	/*dynamic indication*/
	int dyn_ind_allowed = 0;
	int current_bus_code = 0;

	/*static_indication fields*/
	int sseg4, sseg2, sseg1, sseg0;
	sseg4 = sseg2 = sseg1 = sseg0 = MAX_VAL;

	/*for debug*/
	int prev_hash;
	int prev_pc;

	for (int pc = 0;; ++pc) {
		old_a = proc.a;

		/*stay sane*/
		assert_8080(pc >= 0, pc, "pc < 0");
		assert_8080(pc < MEM_SIZE, pc, "pc > MEM_SIZE");
		assert_val_8080(proc.mem[pc], pc);

		/*for debug*/
		int hash = proc.hashs[pc];
		int pair = 0;

		switch (hash) {

		case HLT_H:
			if (verbose) {
				printf("----------regs----------\n");
				machine_print_all_reg();

				/*must be defined manually*/

				for (int i = 0; i < ft_size; i++) {

					/*assertions*/
					assert_8080(from[i] >= 0, i, "from[i] >= 0");
					assert_8080(from[i] < MEM_SIZE, i, "from[i] < MEM_SIZE");
					assert_8080(to[i] >= 0, i, "to[i] >= 0");
					assert_8080(to[i] < MEM_SIZE, i, "to[i] < MEME_SIZE");

					/*print*/
					printf("----------mem(%o-%o)---------\n", from[i], to[i]);
					machine_print_mem(from[i], to[i]);
				}

				printf("----------flags---------\n");
			}
			return;

		case LXI_H:
			/*stay_sane*/
			assert_val_8080(proc.mem[pc + 1], pc + 1);
			assert_val_8080(proc.mem[pc + 2], pc + 2);

			machine_set_reg_pair(hash, B2(proc.mem[pc]), proc.mem[pc + 1],
					proc.mem[pc + 2]);
			pc += 2;
			break;

		case MOV_H:
			set_reg_by_code(B2(proc.mem[pc]),
					get_reg_by_code(B1(proc.mem[pc])));
			break;

		case PUSH_H:
			var = B2(proc.mem[pc]);
			if (var == A_CODE - 1) {
				machine_update_reg_pair(A_CODE, pc);
//				printf("%o:PUSH PSW, A = %o %o\n", pc,proc.a,proc.reg_pair[0]);
			} else
				machine_update_reg_pair(B2(proc.mem[pc]), pc);
			proc.mem[proc.sp - 1] = proc.reg_pair[0];
			proc.mem[proc.sp - 2] = proc.reg_pair[1];
			proc.sp -= 2;
			break;

		case POP_H:
			machine_update_reg_pair(B2(proc.mem[pc]), pc);
			var = B2(proc.mem[pc]);
			if (var == 6) {
//				printf("%o:POP PSW, A = %o\n", pc,proc.reg_pair[0]);
				machine_set_reg_pair(hash, 7, proc.mem[proc.sp],
						proc.mem[proc.sp + 1]);
			} else {
				machine_set_reg_pair(hash, B2(proc.mem[pc]), proc.mem[proc.sp],
						proc.mem[proc.sp + 1]);
			}
			proc.sp += 2;
			break;

		case LDA_H:
			proc.a = proc.mem[(proc.mem[pc+2] << 8) | proc.mem[pc+1]];;
			assert_val_8080(proc.a,pc);
			pc += 2;
			break;

		case SBB_H:
			machine_update_reg_pair(B1(proc.mem[pc]), pc);
			pair = (proc.reg_pair[0] << 8) + proc.reg_pair[1]
					+ ((proc.f >> 4) & 1);
			proc.a =
					((proc.a - pair) > MAX_VAL || (proc.a - pair) < 0) ?
							MAX_VAL + 1 - pair : proc.a - pair;

			fix_reg_overflow(A_CODE);
			assert_val_8080(proc.a,pc);
			break;

		case INX_H:
			machine_update_reg_pair(B2(proc.mem[pc]), pc);
			pair = (proc.reg_pair[0] << 8) | proc.reg_pair[1] + 1;
			machine_set_reg_pair(hash, B2(proc.mem[pc]), pair & MAX_VAL,
					(pair >> 8) & MAX_VAL);
			break;

		case INR_H:
			set_reg_by_code(B2(proc.mem[pc]),
					get_reg_by_code(B2(proc.mem[pc])) + 1);

			fix_reg_overflow(B2(proc.mem[pc]));
			assert_val_8080(B2(proc.mem[pc]),pc);
			assert_val_8080(get_reg_by_code(B2(proc.mem[pc])),pc);

			proc.f &= 0xbf;
			if (get_reg_by_code(B2(proc.mem[pc])) == 0)
				proc.f |= FLAG_ZERO;


			break;

		case DCR_H:
			set_reg_by_code(B2(proc.mem[pc]),
					get_reg_by_code(B2(proc.mem[pc])) - 1);

			fix_reg_overflow(B2(proc.mem[pc]));
			assert_val_8080(B2(proc.mem[pc]),pc);
			assert_val_8080(get_reg_by_code(B2(proc.mem[pc])),pc);
			proc.f &= 0xbf;
			if (get_reg_by_code(B2(proc.mem[pc])) == 0)
				proc.f |= FLAG_ZERO;

			break;

		case ADC_H:
			machine_update_reg_pair(B1(proc.mem[pc]), pc);
			proc.a += (proc.reg_pair[0] << 8) + proc.reg_pair[1]
					+ GET_AC_B(proc.f);

			fix_reg_overflow(B2(proc.mem[pc]));
			assert_val_8080(B2(proc.mem[pc]),pc);
			break;

		case MVI_H:
			set_reg_by_code(B2(proc.mem[pc]), proc.mem[pc + 1]);
			assert_val_8080(proc.mem[pc+1],pc);
			pc++;
			break;

		case ADD_H:
			proc.f |= ((proc.a & 0xf) + (get_reg_by_code(B1(proc.mem[pc])) & 0xf)> 9) ?
							FLAG_AC : 0;

			proc.a += get_reg_by_code(B1(proc.mem[pc]));

			fix_reg_overflow(A_CODE);
			assert_val_8080(proc.a,pc);
			break;

		case SUB_H:
			proc.a -= get_reg_by_code(B1(proc.mem[pc]));

			fix_reg_overflow(proc.a);
			assert_val_8080(proc.a,pc);
			break;

		case SUI_H:
			assert_val_8080(proc.mem[pc + 1],pc+1);
			proc.a -= proc.mem[pc + 1];
			fix_reg_overflow(A_CODE);
			assert_val_8080(proc.a,pc);
			pc++;
			break;

		case DAA_H:
			if ((proc.f >> 4) & 1) {
				proc.a += 0x6;
			}
			if ((proc.a & 0xf) > 9) {
				proc.a += 0x6;
			}
			if (proc.a > 255 | ((proc.a >> 4) & 0xf) > 9) {
				proc.a += 0x60;

			}
			fix_reg_overflow(A_CODE);
			assert_val_8080(proc.a,pc);
			break;

		case JMP_H:
			assert_val_8080(proc.mem[pc+1],pc);
			assert_val_8080(proc.mem[pc+2],pc);

			printf("JMP is working : pc = %o ->", pc);
			pc = (proc.mem[pc + 1] | (proc.mem[pc + 2] << 8)) - 1;
			printf("%o\n", pc + 1);
			break;

		case JNZ_H:
			assert_val_8080(proc.mem[pc+1],pc);
			assert_val_8080(proc.mem[pc+2],pc);

			if (!GET_ZERO_B(proc.f)) {
				printf("JNZ is working : pc = %o ->", pc);
				pc = (proc.mem[pc + 1] | (proc.mem[pc + 2] << 8)) - 1;
				printf("%o\n", pc + 1);
			} else {
				printf("JNZ isn't working : pc = %o ->", pc);
				pc += 2;
				printf("%o\n", pc + 1);
			}
			break;

		case JZ_H:
			assert_val_8080(proc.mem[pc+1],pc);
			assert_val_8080(proc.mem[pc+2],pc);

			if (GET_ZERO_B(proc.f)) {
				printf("JZ is working : pc = %o ->", pc);
				pc = (proc.mem[pc + 1] | (proc.mem[pc + 2] << 8)) - 1;
				printf("%o\n", pc + 1);
			} else {
				printf("JZ isn't working : pc = %o ->", pc);
				pc += 2;
				printf("%o\n", pc + 1);
			}
			break;

		case LDAX_H:
			machine_update_reg_pair(B2(proc.mem[pc]) - 1, pc);
			proc.a = proc.mem[(proc.reg_pair[0] << 8) | proc.reg_pair[1]];
			assert_val_8080(proc.a,pc);
			break;

		case STAX_H:
			machine_update_reg_pair(B2(proc.mem[pc]), pc);
			assert_val_8080(proc.a,pc);
			proc.mem[(proc.reg_pair[0] << 8) | proc.reg_pair[1]] = proc.a;
			break;

		case DAD_H:
			machine_update_reg_pair(B2(proc.mem[pc]) - 1, pc);
			proc.l += proc.reg_pair[1];
			proc.h += proc.reg_pair[0] + fix_reg_overflow(L_CODE);

			assert_val_8080(proc.l,pc);
			assert_val_8080(proc.h,pc);
			break;

		case OUT_H:
			/*check SI allowed*/
			if (proc.mem[pc + 1] == 3 & proc.hashs[pc + 2] == OUT_H
					& proc.mem[pc + 3] == 7 & proc.a == OTD(200)) {

				printf("%o: success, SI was allowed\n", pc);
				stat_ind_allowed = 1;
				pc += 3;

				/*check DI allowed*/
			} else if (proc.mem[pc + 1] == OTD(13) & proc.a == OTD(200)) {
				printf("%o: success, DI was allowed\n", pc);
				dyn_ind_allowed = 1;
				pc += 1;

			} else if (stat_ind_allowed) {

				switch (proc.mem[pc + 1]) {
				case 0:
					sseg0 = proc.a;
					break;
				case 1:
					sseg1 = proc.a;
					break;
				case 2:
					sseg2 = proc.a;
					break;
				case 4:
					sseg4 = proc.a;
					break;
				}
				printf("------%o:OUT %o (A = %o)\n", pc, proc.mem[pc + 1],
						proc.a);
				sseg_print(sseg4);
				sseg_print(sseg2);
				sseg_print(sseg1);
				sseg_print(sseg0);
				printf("---------------------\n");
				pc++;

			} else if (dyn_ind_allowed) {
				if (proc.mem[pc + 1] == OTD(010)) {/*OUT 010;*/
					current_bus_code = proc.a;
					pc++;
				} else if (proc.mem[pc + 1] == OTD(011)) {/*OUT 011;*/
					printf("------%o:DYN_OUT %o (code = %o, indic = %o)\n", pc,
							proc.mem[pc + 1], current_bus_code, proc.a);
					sseg_print(current_bus_code);
					pc += 1;
				}

			} else {

				printf("%o: error, SI does't allowed\n", pc);
				return;
			}
			break;

		case ANI_H:
			assert_val_8080(proc.mem[pc + 1],pc+1);
			proc.a &= proc.mem[pc + 1];
			assert_val_8080(proc.a,pc);
			pc++;
			break;

		case ADI_H:
			assert_val_8080(proc.mem[pc + 1],pc+1);
			proc.a += proc.mem[pc + 1];
			fix_reg_overflow(A_CODE);
			assert_val_8080(proc.a,pc);
//			printf("ADI A = %o\n",proc.a);
			pc++;
			break;

		case RRC_H:
			ovfl = (proc.a & 1) == 1;
			proc.a = ((proc.a >> 1) | (ovfl << 7)) & MAX_VAL;
			break;

		case RLC_H:
			ovfl = ((proc.a >> 7) & 1) == 1;
			proc.a = ((proc.a << 1) | ovfl) & MAX_VAL;
			break;

		case CALL_H:
			assert_val_8080(proc.mem[pc + 1],pc+1);
			assert_val_8080(proc.mem[pc + 2],pc+2);

			proc.mem[proc.sp - 1] = (pc + 3) & MAX_VAL;
			proc.mem[proc.sp - 2] = ((pc + 3) >> 8) & MAX_VAL;
			pc = (proc.mem[pc + 1] | (proc.mem[pc + 2] << 8)) - 1;
			proc.sp -= 2;
			break;

		case RET_H:
			pc = (proc.mem[proc.sp] << 8) + proc.mem[proc.sp + 1] - 1;
			proc.sp += 2;
			break;

		case NOP_H:
			break;

		default:
			printf("Undefined opcode: %o:%o (code = %d)\n", pc, proc.mem[pc],
					hash);
			printf("prev_hash = %o,prev_pc = %o\n\n", prev_hash, prev_pc);

			assert_8080(0, pc, "undefined opcode");

			return;
		}
		prev_pc = pc;
		prev_hash = hash;
		if (proc.a == 0 && proc.a != old_a)
			proc.f |= FLAG_ZERO;

	}
}

/*run regressive tests*/
int test_all(int *from, int *to, int ft_size) {
//	int attach_var = 0;
//	while (!attach_var)
//		attach_var = 0;

	for (int i = 0; i < ft_size; i++) {

		/*assertions*/
		assert_8080(from[i] >= 0, i, "from[i] > 0");
		assert_8080(from[i] < MEM_SIZE, i, "from[i] <= MEM_SIZE");
		assert_8080(to[i] >= 0, i, "to[i] > 0");
		assert_8080(to[i] < MEM_SIZE, i, "to[i] <= MEME_SIZE");

		/*print*/
		printf("----------mem(%o-%o)---------\n", from[i], to[i]);
		machine_print_mem(from[i], to[i]);

		for (int j = from[i]; j <= to[i]; ++j)
			test_assert_8080(test_mem[j],proc.mem[j], j, "regression test error");
	}

	return 0;

}

