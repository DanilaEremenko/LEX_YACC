//#ifndef 8080_EMULATOR_MACHINE_H_
//#define 8080_EMULATOR_MACHINE_H_

#include <stdio.h>

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

#define LXI_OP 1
#define MOV_OP 1

#define MEM_SIZE 1024


struct processor_8086{
	int mem[MEM_SIZE];
	int sp;//TODO check
	int a;//acumul
	int b,c,d,e,h,l,m;//GPR
	int pws;//flag register
}typedef processor_8086;

void machine_init_processor_8086();


void machine_print_mem(int from, int to);

void machine_print_all_reg();


int machine_get_opcode_of_mnem(char *mnem);

int machine_get_code_of_reg(char *reg_name);

void machine_set_reg(char *reg_name, int number);

void machine_set_reg_pair(char *reg_name, int number_1, int number_2);

int machine_get_reg(char *reg_name);

int convert_oct_to_dec(int oct);

//#endif /* 8080_EMULATOR_MACHINE_H_ */
