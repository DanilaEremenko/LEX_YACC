//#ifndef 8080_EMULATOR_MACHINE_H_
//#define 8080_EMULATOR_MACHINE_H_

#include <stdio.h>
#include "codes.h"

#define MAX_VAL		0xff

#define MEM_SIZE 1024

#define B1(val)	 val	& 7
#define B2(val)	 (val>>3) & 7
#define B3(val)	 (val>>6) & 7

struct processor_8086 {
	int mem[MEM_SIZE];
	int hashs[MEM_SIZE];
	int max_sp;
	int sp; //TODO check
	int a; //accumulator
	int b, c, d, e, h, l; //GPR
	int m; //memory
	int f; //flag register
	int psw; //TODO check
	int reg_pair[2]; //current pair
}typedef processor_8086;

void machine_init_processor_8086();

void machine_print_mem(int from, int to);

void machine_print_all_reg();

int machine_get_opcode_of_mnem(char *mnem);

int machine_get_code_of_reg(char *reg_name);

void machine_set_reg(char *reg_name, int number);


int machine_get_reg(char *reg_name);

int OTD(int oct);

void print_inf_8080(int cell_num);

void execute_all();

//#endif /* 8080_EMULATOR_MACHINE_H_ */
