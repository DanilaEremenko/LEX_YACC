//#ifndef 8080_EMULATOR_MACHINE_H_
//#define 8080_EMULATOR_MACHINE_H_

#include <stdio.h>

//REGS CODES
#define A_CODE 7
#define B_CODE 0
#define C_CODE 1
#define D_CODE 2
#define E_CODE 3
#define H_CODE 4
#define L_CODE 5
#define M_CODE 6
#define SP_CODE 10
#define PWS_CODE 11

//OPCODES
#define LXI_OP 1
#define MOV_OP 1
#define INX_OP 3
#define HLT_OP 118

//FLAGS
#define DEF_FLAG	(0<<7)&(0<<6)&(0<<5)&(0<<4)&(0<<3)&(0<<2)&(0<<1)&(1<<0)
#define SIGN 		(1<<7)
#define ZERO 		(1<<6)
#define AC			(1<<4)
#define PARITET		(1<<2)
#define CARRY 		(1<<0)

#define MEM_SIZE 1024

struct processor_8086 {
	int mem[MEM_SIZE];
	int max_sp;
	int sp; //TODO check
	int a; //acumul
	int b, c, d, e, h, l, m; //GPR
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

void machine_set_reg_pair(char *reg_name, int number_1, int number_2);

int machine_get_reg(char *reg_name);

int OTD(int oct);

void print_inf_8080(int cell_num);
//#endif /* 8080_EMULATOR_MACHINE_H_ */
